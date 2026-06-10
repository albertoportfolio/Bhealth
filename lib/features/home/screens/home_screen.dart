import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell shell;

  const HomeScreen({required this.shell, super.key});

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Inicio'),
    NavigationDestination(icon: Icon(Icons.local_drink_rounded), label: 'Alimentación'),
    NavigationDestination(icon: Icon(Icons.bedtime_rounded), label: 'Sueño'),
    NavigationDestination(icon: Icon(Icons.monitor_weight_rounded), label: 'Peso'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) {
          shell.goBranch(index, initialLocation: true);
        },
        destinations: _destinations,
      ),
    );
  }
}
