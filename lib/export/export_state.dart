import 'package:equatable/equatable.dart';
import 'package:my_pesa/errors.dart';

class ExportState extends Equatable {
  const ExportState({
    this.isLoading = false,
    this.error,
    this.success,
  });
  final bool isLoading;
  final UserError? error;
  final String? success;

  ExportState copyWith({bool? isLoading, UserError? error, String? success}) {
    return ExportState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success,
    );
  }

  @override
  List<Object?> get props => [error, success, isLoading];
}

class ExportedState extends ExportState {
  const ExportedState({
    bool isLoading = false,
    UserError? error,
    String? success,
    this.spreadsheetId,
  }) : super(error: error, success: success, isLoading: isLoading);
  final String? spreadsheetId;
  String get spreadsheetUrl =>
      'https://docs.google.com/spreadsheets/d/$spreadsheetId/edit#gid=0';
  @override
  ExportedState copyWith({
    bool? isLoading,
    UserError? error,
    String? success,
    String? spreadsheetId,
  }) {
    return ExportedState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      success: success ?? this.success,
      spreadsheetId: spreadsheetId ?? this.spreadsheetId,
    );
  }
}
