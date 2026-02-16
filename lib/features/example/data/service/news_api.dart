import 'package:cropmodel/core/network/API.dart';

enum NewsApi implements API {
  getHeadlines(Method.get, 'articles');

  final String path;
  final Method method;
  const NewsApi(this.method,this.path);
}