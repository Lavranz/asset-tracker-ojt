import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:apollo_tracker_mobile/commons/utils/image.util.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Picture and Name
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 63 / 2,
                    backgroundImage: AssetImage(ImageConstant.avatar), // Replace with your image path
                  ),
                  const SizedBox(height: 12),
                  if (auth$.currentUser != null)
                    Text(
                      "${auth$.currentUser!.firstName} ${auth$.currentUser!.lastName}",
                      style: AppTextTheme.H5MediumPrimary,
                    ),
                ],
              ),
            ),
            // Options List
            Column(
              children: [
                _buildListTile(
                  icon: PhosphorIcons.calendarCheck(),
                  title: "Attendance",
                  onTap: () {
                    context.push('/attendance');
                  },
                ),
                _buildListTile(
                  icon: PhosphorIcons.fileLock(),
                  title: "Field Service Report",
                  onTap: () {
                    context.push('/fsr');
                  },
                ),
                _buildListTile(
                  icon: PhosphorIcons.mapPin(),
                  title: "View location",
                  onTap: () {
                    context.push('/view-locations');
                  },
                ),
              ],
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.white,
                    shadowColor: Colors.transparent,
                    backgroundColor: AppColors.neutral50,
                    side: const BorderSide(color: AppColors.neutral100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await auth$.logout();
                    queryClient.cache.clear();
                    GoRouter.of(context).go('/login');
                  },
                  child: Text(
                    "Log out from this device",
                    style: AppTextTheme.LabelMdPrimary.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable ListTile Widget with Bottom Border
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.strokePrimary, width: 1),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black, size: 18),
        title: Text(
          title,
          style: AppTextTheme.LabelMdPrimary,
        ),
        trailing: Icon(PhosphorIcons.caretRight(), size: 20),
        onTap: onTap,
      ),
    );
  }
}
