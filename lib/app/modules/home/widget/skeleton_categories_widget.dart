import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCategoriesWidget extends StatelessWidget {
  const SkeletonCategoriesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
        5,
        (index) => SizedBox(
          width: 100,
          height: 30,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
