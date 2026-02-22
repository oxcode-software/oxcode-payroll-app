import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/payroll/domain/models/payslip.dart';
import 'package:oxcode_payroll/features/payroll/presentation/provider/payroll_provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employee = context.read<AuthProvider>().employeeProfile;
      if (employee != null) {
        context.read<PayrollProvider>().fetchPayslips(employee.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(title: "Payroll & Payslips"),
      body: Column(
        children: [
          _buildSalaryOverview(),
          Expanded(
            child: Consumer<PayrollProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.payslips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.fileX,
                          size: 64.w,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No payslips found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(20.w),
                  itemCount: provider.payslips.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final payslip = provider.payslips[index];
                    return _buildPayslipCard(payslip);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryOverview() {
    return Container(
      padding: EdgeInsets.all(24.w),
      color: AppColors.primary,
      child: Column(
        children: [
          Text(
            "ANNUAL GROSS SALARY",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10.sp,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "₹ 5,40,000.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleStat("Basic", "₹ 35,000"),
              _buildSimpleStat("Allowances", "₹ 12,000"),
              _buildSimpleStat("Deductions", "₹ 2,000"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 10.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPayslipCard(Payslip payslip) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.fileText, color: Colors.blue),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payslip.month,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  "Paid on ${DateFormat('dd MMM yyyy').format(payslip.paidAt)}",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹ ${payslip.netSalary.toStringAsFixed(0)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.success,
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  await context
                      .read<PayrollProvider>()
                      .downloadPayslip(payslip.pdfUrl);
                },
                icon: Icon(LucideIcons.download, size: 14.w),
                label: Text("PDF", style: TextStyle(fontSize: 12.sp)),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
