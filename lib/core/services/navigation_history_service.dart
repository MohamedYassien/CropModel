import 'package:shared_preferences/shared_preferences.dart';

class NavigationHistoryService {
  static final NavigationHistoryService _instance = NavigationHistoryService._internal();
  factory NavigationHistoryService() => _instance;
  NavigationHistoryService._internal();

  static const String _lastRouteKey = 'last_route';
  static const String _lastRouteNameKey = 'last_route_name';
  static const String _lastRouteDataKey = 'last_route_data';

  Future<void> saveLastPosition(String route, {String? routeName, String? routeData}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRouteKey, route);
    if (routeName != null) {
      await prefs.setString(_lastRouteNameKey, routeName);
    }
    if (routeData != null) {
      await prefs.setString(_lastRouteDataKey, routeData);
    }
  }

  Future<Map<String, String?>> getLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'route': prefs.getString(_lastRouteKey),
      'routeName': prefs.getString(_lastRouteNameKey),
      'routeData': prefs.getString(_lastRouteDataKey),
    };
  }

  Future<void> clearLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastRouteKey);
    await prefs.remove(_lastRouteNameKey);
    await prefs.remove(_lastRouteDataKey);
  }

  Future<bool> hasSavedPosition() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_lastRouteKey);
  }
}
