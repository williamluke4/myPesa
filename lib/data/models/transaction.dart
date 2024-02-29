// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/utils/parse/mpesa.dart';

part 'transaction.g.dart';

enum TransactionType { IN, OUT, UNKNOWN }

enum AccountType { MPESA }

@JsonSerializable()
class Transaction extends Equatable {
  Transaction({
    this.recipient = '',
    required this.ref,
    this.accountType = AccountType.MPESA,
    this.account = '',
    this.amount = '',
    this.txCost = '',
    this.balance = '',
    this.notes = '',
    this.type = TransactionType.UNKNOWN,
    String? categoryId,
    this.body = '',
    this.dateTime,
    int? lastModified,
  })  : date = dateTime != null ? dateTimeToString(dateTime) : '',
        categoryId = categoryId ?? defaultCategory.id,
        lastModified = lastModified ?? DateTime.now().millisecondsSinceEpoch;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  bool get isDefaultCategory => categoryId == Category.none().id;

  bool get isModified => !isDefaultCategory || notes.isNotEmpty;
  double get getSignedAmount =>
      getAmount * (type == TransactionType.OUT ? -1 : 1);
  double get getAmount => double.tryParse(amount.replaceAll(',', '')) ?? 0;

  final String amount;
  final String ref;
  final String txCost;
  final String recipient;
  final String date;
  final String balance;
  final AccountType accountType;
  final String account;
  final String body;
  final String notes;
  final int lastModified;
  final DateTime? dateTime;
  final String categoryId;
  final TransactionType type;

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  Transaction merge(Transaction tx) {
    // Not the same tx
    // ignore: avoid_returning_this
    if (tx.ref != ref) return this;

    final newest = tx.lastModified > lastModified ? tx : this;
    final oldest = tx.lastModified < lastModified ? tx : this;

    var categoryId = newest.categoryId;
    var notes = newest.notes;

    if (newest.isDefaultCategory && !oldest.isDefaultCategory) {
      categoryId = oldest.categoryId;
    }
    if (newest.notes.isEmpty && oldest.notes.isNotEmpty) {
      notes = oldest.notes;
    }
    return newest.copyWith(categoryId: categoryId, notes: notes);
  }

  Transaction copyWith({
    String? amount,
    String? ref,
    AccountType? accountType,
    String? account,
    String? txCost,
    String? recipient,
    String? date,
    String? balance,
    String? notes,
    String? body,
    DateTime? dateTime,
    String? categoryId,
    TransactionType? type,
  }) {
    return Transaction(
      amount: amount ?? this.amount,
      ref: ref ?? this.ref,
      txCost: txCost ?? this.txCost,
      accountType: accountType ?? this.accountType,
      account: account ?? this.account,
      recipient: recipient ?? this.recipient,
      balance: balance ?? this.balance,
      notes: notes ?? this.notes,
      body: body ?? this.body,
      dateTime: dateTime ?? this.dateTime,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      lastModified: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  List<Object?> get props => [
        amount,
        ref,
        txCost,
        recipient,
        balance,
        body,
        notes,
        accountType,
        account,
        dateTime,
        categoryId,
        lastModified,
        type,
      ];
}
