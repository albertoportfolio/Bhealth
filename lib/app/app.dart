import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import 'router.dart';
import 'theme.dart';
 
class BabyTrackerApp extends ConsumerWidget {
  const BabyTrackerApp({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
 
    return MaterialApp.router(
      title: 'Baby Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
 