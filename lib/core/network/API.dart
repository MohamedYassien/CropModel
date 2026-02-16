enum Method {post, get, put, delete}

abstract class API {
  final String path;
  final Method method;

  API(this.path, this.method);
}