import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class SliverGridDelegateWithFixedCrossAxisCountAndMainAxisExtent
    extends SliverGridDelegate {
  /// Creates a delegate that makes grid layouts with a fixed number of tiles in
  /// the cross axis and a fixed main axis extent.
  ///
  /// All of the arguments must not be null. The `mainAxisSpacing` and
  /// `crossAxisSpacing` arguments must not be negative. The `crossAxisCount`
  /// and `mainAxisExtent` arguments must be greater than zero.
  const SliverGridDelegateWithFixedCrossAxisCountAndMainAxisExtent({
    required this.crossAxisCount,
    required this.mainAxisExtent,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  });

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The main-axis extent of each child.
  final double mainAxisExtent;

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0, 'crossAxisCount must me grater than 0');
    assert(
      mainAxisSpacing >= 0.0,
      'mainAxisSpacing must me grater than or equal to 0',
    );
    assert(
      crossAxisSpacing >= 0.0,
      'crossAxisSpacing must me grater than or equal to 0',
    );
    assert(mainAxisExtent > 0.0, 'mainAxisExtent must me grater than 0');
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid(), 'Layout Args must be valid');
    final double usableCrossAxisExtent = math.max(
      0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );
    final childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final childMainAxisExtent = mainAxisExtent;
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(
    SliverGridDelegateWithFixedCrossAxisCountAndMainAxisExtent oldDelegate,
  ) {
    return oldDelegate.crossAxisCount != crossAxisCount ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.mainAxisExtent != mainAxisExtent;
  }
}
