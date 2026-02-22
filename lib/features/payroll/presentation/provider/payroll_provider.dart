import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oxcode_payroll/features/payroll/domain/models/payslip.dart';
import 'package:printing/printing.dart';

class PayrollProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Payslip> _payslips = [];
  bool _isLoading = false;

  List<Payslip> get payslips => List.unmodifiable(_payslips);
  bool get isLoading => _isLoading;

  Future<void> fetchPayslips(String employeeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('payroll')
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('paidAt', descending: true)
          .get();
      _payslips = snapshot.docs
          .map((doc) => Payslip.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error fetching payslips: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadPayslip(String pdfPathOrUrl) async {
    String url = pdfPathOrUrl;
    if (!pdfPathOrUrl.toLowerCase().startsWith('http')) {
      url = await FirebaseStorage.instance.ref(pdfPathOrUrl).getDownloadURL();
    }
    final bytes = (await http.get(Uri.parse(url))).bodyBytes;
    await Printing.sharePdf(bytes: bytes, filename: 'payslip.pdf');
  }
}
