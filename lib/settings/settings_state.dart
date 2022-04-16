import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pesa/data/models/transaction.dart';

import 'package:my_pesa/errors.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.isLoading = false,
    this.user,
    this.error,
    this.themeMode = ThemeMode.system,
    this.transactions = const <Transaction>[],
    this.balance,
  });
  final bool isLoading;
  final GoogleSignInAccount? user;
  final UserError? error;
  final String? balance;
  final List<Transaction> transactions;
  final ThemeMode themeMode;

  // ignore: flutter_style_todos
  // TODO(williamluke4):  Add SpreadsheetID
  SettingsState copyWith({
    bool? isLoading,
    GoogleSignInAccount? user,
    UserError? error,
    String? balance,
    List<Transaction>? transactions,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      themeMode: themeMode ?? this.themeMode,
      user: user ?? this.user,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, error, user, transactions, balance, themeMode];
}
