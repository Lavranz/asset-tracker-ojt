import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:flutter/material.dart';

customAppBar(String title) {
  return AppBar(
    titleSpacing: 0.0,
    surfaceTintColor: Colors.transparent,
    title: Text(
      title,
      style: AppTextTheme.H6MediumPrimarySMB,
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0), // Height of the bottom border
      child: Container(
        color: AppColors.strokePrimary, // Border color
        height: 1.0, // Border thickness
      ),
    ),
  );
}
