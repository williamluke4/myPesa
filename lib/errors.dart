class AuthError extends Error {
  AuthError({this.error}) : super();
  final int code = 404;
  String get message => '$code: Authentication Error';
  final Object? error;
}
