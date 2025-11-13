import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const SizedBox(height: 8),

        // Header shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(context, 48, 48, isCircle: true),
              _buildShimmerBox(context, 120, 24),
              _buildShimmerBox(context, 48, 48, isCircle: true),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Net Balance shimmer
        Center(
          child: Column(
            children: [
              _buildShimmerBox(context, 100, 16),
              const SizedBox(height: 8),
              _buildShimmerBox(context, 200, 48),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Income/Expense cards shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _buildCardShimmer(context, 120)),
              const SizedBox(width: 16),
              Expanded(child: _buildCardShimmer(context, 120)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Spending trend shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildCardShimmer(context, 220),
        ),
        const SizedBox(height: 16),

        // Financial ratios shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _buildCardShimmer(context, 100)),
              const SizedBox(width: 16),
              Expanded(child: _buildCardShimmer(context, 100)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Accounts breakdown shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBox(context, 180, 20),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    _buildCardShimmer(context, 100, width: 140),
                    const SizedBox(width: 12),
                    _buildCardShimmer(context, 100, width: 140),
                    const SizedBox(width: 12),
                    _buildCardShimmer(context, 100, width: 140),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Biggest expense/category shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildCardShimmer(context, 160),
              const SizedBox(height: 16),
              _buildCardShimmer(context, 140),
            ],
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildShimmerBox(
    BuildContext context,
    double width,
    double height, {
    bool isCircle = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.05),
      highlightColor: colorScheme.onSurface.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.onSurface,
          borderRadius: isCircle
              ? BorderRadius.circular(height / 2)
              : BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCardShimmer(
    BuildContext context,
    double height, {
    double? width,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.05),
      highlightColor: colorScheme.onSurface.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.onSurface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
