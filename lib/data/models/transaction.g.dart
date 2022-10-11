// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      recipient: json['recipient'] as String? ?? '',
      ref: json['ref'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      txCost: json['txCost'] as String? ?? '',
      balance: json['balance'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      type: $enumDecodeNullable(_$TransactionTypeEnumMap, json['type']) ??
          TransactionType.UNKNOWN,
      categoryId: json['categoryId'] as String?,
      body: json['body'] as String? ?? '',
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      lastModified: json['lastModified'] as int?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'ref': instance.ref,
      'txCost': instance.txCost,
      'recipient': instance.recipient,
      'balance': instance.balance,
      'body': instance.body,
      'notes': instance.notes,
      'lastModified': instance.lastModified,
      'dateTime': instance.dateTime?.toIso8601String(),
      'categoryId': instance.categoryId,
      'type': _$TransactionTypeEnumMap[instance.type],
    };

const _$TransactionTypeEnumMap = {
  TransactionType.IN: 'IN',
  TransactionType.OUT: 'OUT',
  TransactionType.UNKNOWN: 'UNKNOWN',
};
