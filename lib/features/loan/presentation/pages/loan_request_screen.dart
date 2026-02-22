import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/loan/domain/models/loan_request.dart';
import 'package:oxcode_payroll/features/loan/presentation/provider/loan_provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  int _tenureMonths = 3;

  double get _emiAmount {
    if (_amountController.text.isEmpty) return 0;
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount / _tenureMonths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(title: "Request Advance"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            SizedBox(height: 24.h),
            Text(
              "Advance Amount (₹)",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Enter amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                prefixIcon: const Icon(LucideIcons.indianRupee),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Tenure (Months)",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            _buildTenureSelector(),
            SizedBox(height: 24.h),
            Text(
              "Reason",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Why do you need this advance?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _buildEMISummary(),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  "Submit Request",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.info, color: AppColors.primary, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "You can request up to 50% of your gross monthly salary as an advance.",
              style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenureSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [3, 6, 9, 12].map((m) {
        final isSelected = _tenureMonths == m;
        return GestureDetector(
          onTap: () => setState(() => _tenureMonths = m),
          child: Container(
            width: 70.w,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
            ),
            child: Center(
              child: Text(
                "$m M",
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEMISummary() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Estimated EMI",
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
              ),
              Text(
                "₹ ${_emiAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Total Interest",
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
              ),
              Text(
                "₹ 0.00",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (_amountController.text.isEmpty || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final auth = context.read<AuthProvider>();
    final employee = auth.employeeProfile;
    if (employee == null) return;

    final request = LoanAdvanceRequest(
      id: const Uuid().v4(),
      employeeId: employee.id,
      amount: double.parse(_amountController.text),
      tenureMonths: _tenureMonths,
      emiAmount: _emiAmount,
      reason: _reasonController.text,
      createdAt: DateTime.now(),
    );

    try {
      await context.read<LoanProvider>().submitRequest(request);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Loan request submitted successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error submitting request")));
    }
  }
}
