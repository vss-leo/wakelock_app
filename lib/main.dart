import 'package:flutter/material.dart';
import 'theme/theme.dart';
import '../app/routes.dart';

void main() {
  runApp(const WakelockApp());
}

class WakelockApp extends StatelessWidget {
  const WakelockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: createRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
