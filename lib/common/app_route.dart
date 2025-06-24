import 'package:flutter/material.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/pages/dashboard.dart';

class AppRoute {
  static const dashboard = '/';
  static const detailDestination = '/destination/detail';
  static const searchDestination = '/destination/search';

  static Route<dynamic>? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case detailDestination:
        // return MaterialPageRoute(builder: (_) => DetailDestinationPage());
        break;
      case searchDestination:
        // return MaterialPageRoute(builder: (_) => SearchDestinationPage());
        break;
      default:
        return _notFoundPage;
    }
    return _notFoundPage;
  }

  static MaterialPageRoute get _notFoundPage {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(child: Text('Page Not Found')),
          ),
    );
  }
}
