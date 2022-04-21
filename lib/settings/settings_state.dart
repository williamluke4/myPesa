import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pesa/data/export.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/errors.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.isLoading = false,
    this.user,
    this.error,
    this.themeMode = ThemeMode.system,
    this.exportType = ExportType.single,
    this.transactions = const <Transaction>[],
    this.balance,
    this.spreadsheetId,
  });
  // TODO: I think theres a bug here
  factory SettingsState.fromJson(Map<String, dynamic> map) {
    return SettingsState(
      balance: map['balance'] as String,
      exportType: ExportType.values.byName(map['exportType'] as String),
      transactions: (map['transactions'] as List<dynamic>)
          .map<Transaction>(Transaction.fromJson)
          .toList(),
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
  final String? balance;
  final ExportType exportType;
  final List<Transaction> transactions;
  final ThemeMode themeMode;
  final String? spreadsheetId;

  SettingsState copyWith({
    bool? isLoading,
    GoogleSignInAccount? user,
    UserError? error,
    ExportType? exportType,
    String? spreadsheetId,
    String? balance,
    List<Transaction>? transactions,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Do not copy error
      themeMode: themeMode ?? this.themeMode,
      exportType: exportType ?? this.exportType,
      spreadsheetId: spreadsheetId ?? this.spreadsheetId,
      user: user ?? this.user,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }

  SettingsState signout() {
    return SettingsState(
      isLoading: isLoading,
      themeMode: themeMode,
      balance: balance,
      transactions: transactions,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        user,
        transactions,
        balance,
        themeMode,
        exportType,
        spreadsheetId
      ];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isLoading': isLoading,
        'balance': balance,
        'spreadsheetId': spreadsheetId,
        'exportType': exportType.name,
        'transactions': transactions.map<dynamic>((x) => x.toJson()).toList(),
        'themeMode': themeMode.name,
      };
}
