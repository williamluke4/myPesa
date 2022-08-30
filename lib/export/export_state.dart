import 'package:equatable/equatable.dart';
import 'package:my_pesa/errors.dart';

class ExportState extends Equatable {
  const ExportState({
    this.isLoading = false,
    this.error,
  });
  final bool isLoading;
  final UserError? error;

  ExportState copyWith({
    bool? isLoading,
    UserError? error,
  }) {
    return ExportState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [error, isLoading];
}

class ExportedState extends ExportState {
  const ExportedState({
    bool isLoading = false,
    UserError? error,
    this.spreadsheetId,
  }) : super(error: error, isLoading: isLoading);
  final String? spreadsheetId;
  String get spreadsheetUrl =>
      'https://docs.google.com/spreadsheets/d/$spreadsheetId/edit#gid=0';
  @override
  ExportedState copyWith({
    bool? isLoading,
    UserError? error,
    String? spreadsheetId,
  }) {
    return ExportedState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      spreadsheetId: spreadsheetId ?? this.spreadsheetId,
    );
  }
}
