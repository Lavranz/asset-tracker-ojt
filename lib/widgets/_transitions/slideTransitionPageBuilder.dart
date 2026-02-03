
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


CustomTransitionPage<dynamic> slideTransitionPageBuilder(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<dynamic>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400), // Shorter duration
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      final Animation<Offset> slideAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut, // Smooth and slightly fast easing curve
      ));
      return SlideTransition(
        position: slideAnimation,
        child: child,
      );
    },
  );
}