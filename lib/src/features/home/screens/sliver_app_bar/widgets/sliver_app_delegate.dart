import 'dart:math' as math;

import 'package:flutter/material.dart';

typedef SliverAppBarDelegateBuilder = Widget Function(
  BuildContext context,
  double shrinkOffset,
);

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });

  final SliverAppBarDelegateBuilder builder;
  final double maxHeight;
  final double minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: builder(context, shrinkOffset),
    );
  }
}
