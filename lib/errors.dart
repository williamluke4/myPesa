class AuthError extends Error {
  AuthError({this.error}) : super();
  int get code => 404;
  String get message => '$code: Authentication Error';
  final Object? error;
}
