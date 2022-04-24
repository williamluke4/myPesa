import 'package:my_pesa/errors.dart';

class ExportState {
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
}

class ExportedState extends ExportState {
  const ExportedState({
    bool isLoading = false,
    UserError? error,
    this.spreadsheetId,
  }) : super(error: error, isLoading: isLoading);
  final String? spreadsheetId;

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
