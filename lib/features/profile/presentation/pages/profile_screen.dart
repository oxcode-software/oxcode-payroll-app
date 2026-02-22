import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:oxcode_payroll/features/auth/domain/models/employee_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final employee = auth.employeeProfile;

    if (employee == null) {
      return const Scaffold(body: Center(child: Text("No profile data")));
    }

    return Scaffold(
      appBar: const PremiumAppBar(title: "My Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(employee),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _buildProfileSection("Personal Information", [
                    _buildInfoTile(LucideIcons.mail, "Email", employee.email),
                    _buildInfoTile(LucideIcons.phone, "Phone", employee.phone),
                    _buildInfoTile(
                      LucideIcons.calendar,
                      "Joining Date",
                      employee.joiningDate.toString().split(' ')[0],
                    ),
                  ]),
                  SizedBox(height: 20.h),
                  _buildProfileSection("Bank Details", [
                    _buildInfoTile(
                      LucideIcons.landmark,
                      "Bank Name",
                      employee.bankName ?? "Not Set",
                    ),
                    _buildInfoTile(
                      LucideIcons.creditCard,
                      "Account Number",
                      employee.accountNumber ?? "Not Set",
                    ),
                    _buildInfoTile(
                      LucideIcons.hash,
                      "IFSC Code",
                      employee.ifscCode ?? "Not Set",
                    ),
                  ]),
                  SizedBox(height: 20.h),
                  _buildProfileSection("Emergency Contact", [
                    _buildInfoTile(
                      LucideIcons.user,
                      "Relation / Name",
                      employee.emergencyContactName ?? "Not Set",
                    ),
                    _buildInfoTile(
                      LucideIcons.phoneCall,
                      "Contact Number",
                      employee.emergencyContactPhone ?? "Not Set",
                    ),
                  ]),
                  SizedBox(height: 40.h),
                  _buildLogoutButton(context, auth),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(EmployeeModel employee) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.white24,
            child: Icon(LucideIcons.user, size: 50.w, color: Colors.white),
          ),
          SizedBox(height: 16.h),
          Text(
            employee.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${employee.designation} • ${employee.department}",
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children
                .expand(
                  (w) => [
                    w,
                    if (w != children.last)
                      Divider(color: Colors.grey[100], height: 24.h),
                  ],
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20.w),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton.icon(
        onPressed: () {
          auth.logout();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Center(child: Text("Logged Out")),
            ), // Replace with LoginScreen if needed
            (route) => false,
          );
        },
        icon: const Icon(LucideIcons.logOut, color: Colors.red),
        label: Text(
          "Logout",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}
