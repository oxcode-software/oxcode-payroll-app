import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import {logger} from "firebase-functions";
import {onRequest} from "firebase-functions/v2/https";
import axios from "axios";

admin.initializeApp();

const MSG91_AUTH_KEY = "485786AC5O0R4nz6980be82P1";
const MSG91_WIDGET_ID = "366161713076343033393134";

interface Msg91VerifyResponse {
  message?: string;
}

interface Msg91PhoneResponse {
  data?: {
    phone?: string;
  };
}

/**
 * Trigger OTP via MSG91 (Callable v1)
 * Reverted to v1 because Firebase doesn't support 1st to 2nd gen upgrades
 * without first deleting the old function.
 */
export const sendOtp = functions.region("us-central1")
  .https.onCall(async (data) => {
    const {phoneNumber} = data;
    logger.info("sendOtp started for:", phoneNumber);

    if (!phoneNumber) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing phone."
      );
    }

    try {
      const url = "https://api.msg91.com/api/v5/otp";
      const response = await axios.post(url, {
        widgetId: MSG91_WIDGET_ID,
        mobile: phoneNumber,
      }, {
        headers: {
          "authkey": MSG91_AUTH_KEY,
          "Content-Type": "application/json",
        },
      });

      return {
        success: response.data.type === "success",
        message: response.data.message,
        data: response.data,
      };
    } catch (error: unknown) {
      const err = error as { response?: { data?: unknown }; message?: string };
      logger.error("Error sending OTP:", err.response?.data || err.message);
      throw new functions.https.HttpsError("internal", "Failed to send OTP.");
    }
  });

/**
 * Verify MSG91 Access Token and Get Custom Token
 * (HTTP Request v2)
 */
export const verifyMsg91OtpAndGetCustomToken = onRequest(
  {
    cors: true,
    timeoutSeconds: 300,
    invoker: "public",
    region: "us-central1",
  },
  async (req, res) => {
    try {
      const {msg91Token} = req.body;

      if (!msg91Token) {
        res.status(400).json({error: "Missing msg91Token"});
        return;
      }

      // Verify Token with MSG91
      const msg91Res = await fetch(
        "https://control.msg91.com/api/v5/widget/verifyAccessToken",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: JSON.stringify({
            "authkey": MSG91_AUTH_KEY,
            "access-token": msg91Token,
          }),
        }
      );

      const msg91Data = (await msg91Res.json()) as Msg91VerifyResponse;

      if (!msg91Res.ok || !msg91Data?.message) {
        res.status(400).json({error: "Invalid or expired OTP"});
        return;
      }

      const message = msg91Data.message;
      let phoneNumber: string;

      // Extract phone number from response or JWT
      if (typeof message === "string" &&
          (message.startsWith("+") || /^\d+$/.test(message))) {
        phoneNumber = message.startsWith("+") ? message : `+${message}`;
      } else {
        if (!message || typeof message !== "string") {
          logger.error("Invalid message received:", message);
          res.status(400).json({error: "Invalid verification response"});
          return;
        }

        const jwtParts = message.split(".");
        if (jwtParts.length !== 3) {
          res.status(400).json({error: "Invalid JWT token structure"});
          return;
        }

        const payload = jwtParts[1];
        const decodedToken = JSON.parse(
          Buffer.from(payload, "base64").toString()
        );
        const requestId = decodedToken.requestId;

        const phoneRes = await fetch(
          "https://control.msg91.com/api/v5/widget/getRequestDetails",
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: JSON.stringify({
              "authkey": MSG91_AUTH_KEY,
              "request-id": requestId,
            }),
          }
        );

        const phoneData = (await phoneRes.json()) as Msg91PhoneResponse;
        if (!phoneRes.ok || !phoneData?.data?.phone) {
          res.status(400).json({error: "Failed to get phone number"});
          return;
        }
        phoneNumber = phoneData.data.phone;
      }

      const formattedPhone = phoneNumber.startsWith("+") ?
        phoneNumber : `+${phoneNumber}`;

      // Find/Create User and Look up Companies
      const employeesSnapshot = await admin.firestore()
        .collection("employees")
        .where("phone", "==", formattedPhone)
        .get();

      const companies = employeesSnapshot.docs.map((doc) => ({
        uid: doc.id,
        companyName: doc.data().companyName || "Unknown Company",
        companyCode: doc.data().companyCode,
      }));

      // Find or Create Auth User based on first employee or generic
      let firebaseUid: string;
      if (companies.length > 0) {
        firebaseUid = companies[0].uid;
      } else {
        try {
          const userRecord = await admin.auth()
            .getUserByPhoneNumber(formattedPhone);
          firebaseUid = userRecord.uid;
        } catch (error: unknown) {
          const err = error as { code?: string };
          if (err.code === "auth/user-not-found") {
            const newUser = await admin.auth().createUser({
              phoneNumber: formattedPhone,
            });
            firebaseUid = newUser.uid;
          } else {
            throw error;
          }
        }
      }

      const firebaseToken = await admin.auth().createCustomToken(firebaseUid);
      res.status(200).json({
        firebaseToken,
        phoneNumber: formattedPhone,
        companies: companies, // Returning companies for the selection dialog
      });
    } catch (err: unknown) {
      const error = err as { message?: string };
      logger.error("Error verifying OTP:", error);
      res.status(500).json({error: error.message || "Internal server error"});
    }
  }
);
