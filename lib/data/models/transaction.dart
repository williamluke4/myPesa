import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/utils/parse/mpesa.dart';

part 'transaction.g.dart';

// ignore: constant_identifier_names
enum TransactionType { IN, OUT, UNKNOWN }

@JsonSerializable()
class Transaction extends Equatable {
  Transaction({
    this.recipient = '',
    this.ref = '',
    this.amount = '',
    this.txCost = '',
    this.balance = '',
    this.notes = '',
    this.type = TransactionType.UNKNOWN,
    String? categoryId,
    this.body = '',
    this.dateTime,
  })  : date = dateTime != null ? dateTimeToString(dateTime) : '',
        categoryId = categoryId ?? defaultCategory.id;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  final String amount;
  final String ref;
  final String txCost;
  final String recipient;
  final String date;
  final String balance;
  final String body;
  final String notes;

  final DateTime? dateTime;
  final String categoryId;
  final TransactionType type;

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  Transaction copyWith({
    String? amount,
    String? ref,
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
      recipient: recipient ?? this.recipient,
      balance: balance ?? this.balance,
      notes: notes ?? this.notes,
      body: body ?? this.body,
      dateTime: dateTime ?? this.dateTime,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
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
        dateTime,
        categoryId,
        type
      ];
}
