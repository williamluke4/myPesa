import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pesa/errors.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.isLoading = false,
    this.user,
    this.error,
    this.themeMode = ThemeMode.system,
    this.spreadsheetId,
  });
  factory SettingsState.fromJson(Map<String, dynamic> map) {
    return SettingsState(
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
  final ThemeMode themeMode;
  final String? spreadsheetId;

  SettingsState copyWith({
    bool? isLoading,
    GoogleSignInAccount? user,
    UserError? error,
    String? spreadsheetId,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Do not copy error
      themeMode: themeMode ?? this.themeMode,
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
  List<Object?> get props => [isLoading, error, user, themeMode, spreadsheetId];

  Map<String, dynamic> toJson(SettingsState state) {
    return <String, dynamic>{
      'spreadsheetId': state.spreadsheetId,
      'themeMode': state.themeMode.name,
    };
  }
}
