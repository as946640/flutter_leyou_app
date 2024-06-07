import 'package:flutter/widgets.dart';

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget Function(double shrinkOffset, bool overlapsContent) buildChild;
  final double maxHeight;
  final double minHeight;

  StickyHeaderDelegate({
    required this.buildChild,
    this.maxHeight = 50.0,
    this.minHeight = 50.0,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return buildChild(shrinkOffset, overlapsContent);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
