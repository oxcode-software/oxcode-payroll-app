import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/expense/domain/models/expense_claim.dart';
import 'package:oxcode_payroll/features/expense/presentation/provider/expense_provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ExpenseSubmitScreen extends StatefulWidget {
  const ExpenseSubmitScreen({super.key});

  @override
  State<ExpenseSubmitScreen> createState() => _ExpenseSubmitScreenState();
}

class _ExpenseSubmitScreenState extends State<ExpenseSubmitScreen> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.travel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(title: "Submit Claim"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            _buildCategorySelector(),
            SizedBox(height: 24.h),
            Text(
              "Amount (₹)",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "0.00",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                prefixIcon: const Icon(LucideIcons.indianRupee),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Description",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "What was this expense for?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _buildImagePickerPlaceholder(),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: _submitClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  "Submit Claim",
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

  Widget _buildCategorySelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ExpenseCategory>(
          value: _selectedCategory,
          isExpanded: true,
          items: ExpenseCategory.values.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedCategory = val!),
        ),
      ),
    );
  }

  Widget _buildImagePickerPlaceholder() {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.camera, color: Colors.grey, size: 32.w),
          SizedBox(height: 8.h),
          Text(
            "Upload Receipt Photo",
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Future<void> _submitClaim() async {
    if (_amountController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final employee = auth.employeeProfile;
    if (employee == null) return;

    final claim = ExpenseClaim(
      id: const Uuid().v4(),
      employeeId: employee.id,
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      description: _descController.text,
      createdAt: DateTime.now(),
    );

    try {
      await context.read<ExpenseProvider>().submitClaim(claim);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Expense claim submitted successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error submitting claim")));
    }
  }
}
