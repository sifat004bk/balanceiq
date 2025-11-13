import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildShimmerBox(48, 48, isCircle: true),
              _buildShimmerBox(120, 24),
              _buildShimmerBox(48, 48, isCircle: true),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Net Balance shimmer
        Center(
          child: Column(
            children: [
              _buildShimmerBox(100, 16),
              const SizedBox(height: 8),
              _buildShimmerBox(200, 48),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Income/Expense cards shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _buildCardShimmer(120)),
              const SizedBox(width: 16),
              Expanded(child: _buildCardShimmer(120)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Spending trend shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildCardShimmer(220),
        ),
        const SizedBox(height: 16),

        // Financial ratios shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _buildCardShimmer(100)),
              const SizedBox(width: 16),
              Expanded(child: _buildCardShimmer(100)),
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
              _buildShimmerBox(180, 20),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    _buildCardShimmer(100, width: 140),
                    const SizedBox(width: 12),
                    _buildCardShimmer(100, width: 140),
                    const SizedBox(width: 12),
                    _buildCardShimmer(100, width: 140),
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
              _buildCardShimmer(160),
              const SizedBox(height: 16),
              _buildCardShimmer(140),
            ],
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildShimmerBox(double width, double height,
      {bool isCircle = false}) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isCircle
              ? BorderRadius.circular(height / 2)
              : BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCardShimmer(double height, {double? width}) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
