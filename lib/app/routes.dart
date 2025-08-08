import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/intro_nfc_page.dart';
import '../features/onboarding/intro_name_page.dart';
import '../features/alarms/alarms_page.dart';
import '../features/alarms/edit_alarm_sheet.dart';
import '../features/ringing/ringing_page.dart';
import '../features/stats/stats_page.dart';

/// Creates the app router using GoRouter.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const IntroNfcPage(),
      ),
      GoRoute(
        path: '/intro-name',
        builder: (context, state) => const IntroNamePage(),
      ),
      GoRoute(
        path: '/alarms',
        builder: (context, state) => const AlarmsPage(),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => const EditAlarmSheet(),
          ),
          GoRoute(
            path: 'ring',
            builder: (context, state) => const RingingPage(),
          ),
          GoRoute(
            path: 'stats',
            builder: (context, state) => const StatsPage(),
          ),
        ],
      ),
    ],
  );
}