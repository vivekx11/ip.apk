import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_theme.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerLoading.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerLoading.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  const ShimmerLoading.rounded({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}

class ShopShimmer extends StatelessWidget {
  const ShopShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const ShimmerLoading.rounded(width: 60, height: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const SizedBox(height: 8),
                  ShimmerLoading.rectangular(
                    height: 12,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 3,
            child: ShimmerLoading.rounded(height: double.infinity),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ShimmerLoading.rectangular(height: 14, width: double.infinity),
                  const SizedBox(height: 4),
                  ShimmerLoading.rectangular(
                    height: 12,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerLoading.rectangular(
                        height: 16,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      const ShimmerLoading.rounded(width: 24, height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
