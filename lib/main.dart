import 'package:flutter/material.dart';

import 'constants/app_route_observer.dart';
import 'screens/auth/splash_screen.dart';

void main() {
  runApp(const SharedWheelApp());
}

class SharedWheelApp extends StatelessWidget {
  const SharedWheelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SharedWheel',
      navigatorObservers: [appRouteObserver],
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
