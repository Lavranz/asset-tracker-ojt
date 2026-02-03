import 'package:apollo_tracker_mobile/commons/utils/image.util.dart';
import 'package:apollo_tracker_mobile/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
    Widget build(BuildContext context) => Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(height: 2),
        selectedLabelStyle: const TextStyle(height: 2),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: widget.child.currentIndex,
        onTap: (index) {
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
        }, 
        items: <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: Padding(
          //     padding: const EdgeInsets.only(top: 12),
          //     child: PhosphorIcon(
          //       PhosphorIcons.house(),
          //     )
        //   ),
          //   label: 'Home',
          // ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: PhosphorIcon(
                PhosphorIcons.clipboard(),
              )
            ),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: PhosphorIcon(
                  PhosphorIcons.scan(),
                )),
            label: 'Asset Tracker',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: CustomImageView(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                imagePath: ImageConstant.avatar,
                width: 28,
                height: 28,
                radius: BorderRadius.circular(300),
              ),
            ),
            label: 'Profile',
          )
        ]
      )
  );
}