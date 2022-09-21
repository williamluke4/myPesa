import 'package:equatable/equatable.dart';

class UserError extends Equatable {
  const UserError({this.error, required this.message}) : super();
  final String message;
  final Object? error;

  @override
  List<Object?> get props => [message, error];
}

UserError noTransactionsError =
    const UserError(message: 'No Transactions to Export');
UserError signInError = const UserError(message: 'Unable to Sign In');
UserError notSignedInError = const UserError(message: 'Please Sign In');
UserError notAllowedToDeleteError =
    const UserError(message: 'Unable to delete default');
