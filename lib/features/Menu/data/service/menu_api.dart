import 'package:cropmodel/core/network/API.dart';

enum MenuApi implements API {
  getMenu(Method.get, '');

  final String path;
  final Method method;
  const MenuApi(this.method, this.path);
}