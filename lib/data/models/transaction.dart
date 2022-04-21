import 'package:equatable/equatable.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/utils/parse.dart';

// ignore: constant_identifier_names
enum TransactionType { IN, OUT, UNKNOWN }

class Transaction extends Equatable {
  Transaction({
    this.recipient = '',
    this.ref = '',
    this.amount = '',
    this.txCost = '',
    this.balance = '',
    this.type = TransactionType.UNKNOWN,
    this.category = unCategorized,
    this.body = '',
    this.dateTime,
  }) : date = dateTime != null ? dateTimeToString(dateTime) : '';

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'] as String,
      ref: json['ref'] as String,
      txCost: json['txCost'] as String,
      recipient: json['recipient'] as String,
      balance: json['balance'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      body: json['body'] as String,
      dateTime: DateTime.tryParse(json['dateTime'] as String),
      type: json['networkPreset'] is String
          ? TransactionType.values.byName(json['networkPreset'] as String)
          : TransactionType.UNKNOWN,
    );
  }
  final String amount;
  final String ref;
  final String txCost;
  final String recipient;
  final String date;
  final String balance;
  final String body;
  final DateTime? dateTime;
  final Category category;
  final TransactionType type;
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'ref': ref,
      'txCost': txCost,
      'recipient': recipient,
      'category': category.toJson(),
      'balance': balance,
      'body': body,
      'dateTime': dateTime?.toString() ?? '',
      'type': type.name,
    };
  }

  Transaction copyWith({
    String? amount,
    String? ref,
    String? txCost,
    String? recipient,
    String? date,
    String? balance,
    String? body,
    DateTime? dateTime,
    Category? category,
    TransactionType? type,
  }) {
    return Transaction(
      amount: amount ?? this.amount,
      ref: ref ?? this.ref,
      txCost: txCost ?? this.txCost,
      recipient: recipient ?? this.recipient,
      balance: balance ?? this.balance,
      body: body ?? this.body,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props =>
      [amount, ref, txCost, recipient, balance, body, dateTime, category, type];
}
