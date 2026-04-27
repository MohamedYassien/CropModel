import 'package:flutter/material.dart';
import 'navigation_history_service.dart';

class AppRouteObserver extends NavigatorObserver {
  final NavigationHistoryService _historyService = NavigationHistoryService();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _saveRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _saveRoute(newRoute);
    }
  }

  void _saveRoute(Route<dynamic> route) {
    final routeName = route.settings.name;
    if (routeName != null && 
        routeName != '/' && 
        routeName != '/home' &&
        routeName != '/login') {
      _historyService.saveLastPosition(routeName, routeName: routeName);
    }
  }
}
