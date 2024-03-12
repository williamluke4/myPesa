import 'dart:math' as math;

import 'package:my_pesa/data/models/transaction.dart';

String amountToBin(double amount, {double interval = 500.0}) {
  final binIndex = (amount / interval).floor();
  return 'Amount_${binIndex * interval}-${(binIndex + 1) * interval}';
}

List<String> extractFeatures(Transaction tx) {
  final features = <String>[
    tx.account,
    tx.accountType.name,
    tx.type.name,
    tx.getAmount.toString(),
    amountToBin(tx.getAmount),
    ...tx.recipient.split(' '),
    ...tx.recipient.split(' '),
  ];
  if (tx.dateTime != null) {
    features
      ..add('weekday:${tx.dateTime!.weekday}')
      ..add('hour:${tx.dateTime!.hour}')
      ..add('month:${tx.dateTime!.month}');
  }
  return features;
}

class NaiveBayesClassifier {
  Map<String, Map<String, int>> featureCounts = {};
  Map<String, int> categoryCounts = {};
  int totalDocuments = 0;

  void train(String category, List<String> features) {
    categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    totalDocuments += 1;

    for (final feature in features) {
      featureCounts[category] ??= {};
      featureCounts[category]![feature] =
          (featureCounts[category]![feature] ?? 0) + 1;
    }
  }

  void trainAll(List<Transaction> transactions) {
    for (final transaction in transactions) {
      train(transaction.categoryId, extractFeatures(transaction));
    }
  }

  String predict(List<String> features) {
    var bestCategory = '';
    var highestProbability = double.negativeInfinity;

    for (final category in categoryCounts.keys) {
      var categoryProbability =
          math.log((categoryCounts[category] ?? 0) / totalDocuments);
      for (final feature in features) {
        final featureCount = featureCounts[category]?[feature] ?? 0;
        final featureProbability = (featureCount + 1) /
            ((categoryCounts[category] ?? 0) +
                featureCounts.length); // Laplace smoothing
        categoryProbability += math.log(featureProbability);
      }

      if (categoryProbability > highestProbability) {
        bestCategory = category;
        highestProbability = categoryProbability;
      }
    }

    return bestCategory;
  }

  List<(String, double)> predictProbabilities(List<String> features) {
    final probabilities = <(String, double)>[];
    var highestProbability = double.negativeInfinity;

    for (final category in categoryCounts.keys) {
      var categoryProbability =
          math.log((categoryCounts[category] ?? 0) / totalDocuments);
      for (final feature in features) {
        final featureCount = featureCounts[category]?[feature] ?? 0;
        final featureProbability = (featureCount + 1) /
            ((categoryCounts[category] ?? 0) +
                featureCounts.length); // Laplace smoothing
        categoryProbability += math.log(featureProbability);
      }

      if (categoryProbability > highestProbability) {
        highestProbability = categoryProbability;
      }
      probabilities.add((category, categoryProbability));
    }

    return probabilities;
  }
}
