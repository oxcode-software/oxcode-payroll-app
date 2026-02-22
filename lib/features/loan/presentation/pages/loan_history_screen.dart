import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/loan/domain/models/loan_request.dart';
import 'package:oxcode_payroll/features/loan/presentation/provider/loan_provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:oxcode_payroll/features/loan/presentation/pages/loan_request_screen.dart';
import 'package:provider/provider.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _fetchLoans();
  }

  void _fetchLoans() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employee = context.read<AuthProvider>().employeeProfile;
      if (employee != null) {
        context.read<LoanProvider>().fetchRequests(employee.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(title: "Loans & Advances"),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoanRequestScreen()),
        ).then((_) => _fetchLoans()),
        backgroundColor: AppColors.primary,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
      body: Consumer<LoanProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.banknote,
                    size: 64.w,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No loan requests found",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(20.w),
            itemCount: provider.requests.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final request = provider.requests[index];
              return _buildLoanCard(request);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoanCard(LoanAdvanceRequest loan) {
    final statusColor = _getStatusColor(loan.status);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "EMI: ₹ ${loan.emiAmount.toStringAsFixed(0)}/mo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 13.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  loan.status.name.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "₹ ${loan.amount.toStringAsFixed(0)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
          ),
          Text(
            "${loan.tenureMonths} Months Tenure",
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
          SizedBox(height: 12.h),
          Divider(color: Colors.grey[100]),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Applied on ${DateFormat('dd MMM yyyy').format(loan.createdAt)}",
                style: TextStyle(color: Colors.grey[400], fontSize: 11.sp),
              ),
              if (loan.status == LoanStatus.active)
                Text(
                  "Next Due: 05 Feb",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.pending:
        return Colors.orange;
      case LoanStatus.approved:
      case LoanStatus.active:
        return AppColors.success;
      case LoanStatus.completed:
        return Colors.blue;
      case LoanStatus.rejected:
        return AppColors.error;
    }
  }
}
