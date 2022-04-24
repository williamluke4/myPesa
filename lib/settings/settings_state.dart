import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pesa/data/export.dart';
import 'package:my_pesa/errors.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.isLoading = false,
    this.user,
    this.error,
    this.themeMode = ThemeMode.system,
    this.exportType = ExportType.single,
    this.spreadsheetId,
  });
  factory SettingsState.fromJson(Map<String, dynamic> map) {
    return SettingsState(
      exportType: map['exportType'] is String
          ? ExportType.values.byName(map['exportType'] as String)
          : ExportType.split,
      themeMode: ThemeMode.values.byName(
        map['themeMode'] is String
            ? map['themeMode'] as String
            : ThemeMode.system.name,
      ),
      spreadsheetId: map['spreadsheetId'] is String
          ? map['spreadsheetId'] as String
          : null,
    );
  }
  final bool isLoading;
  final GoogleSignInAccount? user;
  final UserError? error;
  final ExportType exportType;
  final ThemeMode themeMode;
  final String? spreadsheetId;

  SettingsState copyWith({
    bool? isLoading,
    GoogleSignInAccount? user,
    UserError? error,
    ExportType? exportType,
    String? spreadsheetId,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Do not copy error
      themeMode: themeMode ?? this.themeMode,
      exportType: exportType ?? this.exportType,
      spreadsheetId: spreadsheetId ?? this.spreadsheetId,
      user: user ?? this.user,
    );
  }

  SettingsState signout() {
    return SettingsState(
      isLoading: isLoading,
      themeMode: themeMode,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, error, user, themeMode, exportType, spreadsheetId];

  Map<String, dynamic> toJson(SettingsState state) {
    return <String, dynamic>{
      'spreadsheetId': state.spreadsheetId,
      'exportType': state.exportType.name,
      'themeMode': state.themeMode.name,
    };
  }
}
