import 'dart:async';

import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

FutureOr<String?> isAuthenticated(
    BuildContext context, GoRouterState state) async {
  if (await auth$.isAuthenticated()) {
    return null;
  }
  return '/asset-tracker';
}

FutureOr<String?> alreadyLogin(
    BuildContext context, GoRouterState state) async {
  if (await auth$.isAuthenticated()) {
  return '/tickets';
  }
  return null;
}