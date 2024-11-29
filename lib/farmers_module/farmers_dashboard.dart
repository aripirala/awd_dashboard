// lib/farmers_module/farmers_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/farmer_provider.dart';
import 'screens/dashboard_screen.dart';

class FarmersDashboardModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FarmerProvider(),
      child: Builder(
        builder: (context) {
          // Fetch data when the widget is first created
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<FarmerProvider>(context, listen: false).fetchFarmers();
          });
          return DashboardScreen();
        },
      ),
    );
  }
}

// Usage in existing app:
// routing/navigation.dart
getRoute() {
  return {
    '/farmers': (context) => FarmersDashboardModule(),
    // other routes...
  };
}
