import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/rating_model.dart';
import '../../services/rating_service.dart';
import '../../widgets/loading_widget.dart';

class UserReviewsScreen extends StatefulWidget {
  final int userId;
  final String userName;

  const UserReviewsScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<UserReviewsScreen> createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends State<UserReviewsScreen> {
  final RatingService ratingService = RatingService();

  bool isLoading = true;
  double averageRating = 0;
  int totalRatings = 0;
  List<RatingModel> reviews = [];

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

  Future<void> loadReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ratingService.getUserRatings(widget.userId);
      if (result['success'] == true) {
        averageRating = double.tryParse(result['user']['rating'].toString()) ?? 0;
        totalRatings = int.tryParse(result['user']['total_ratings'].toString()) ?? 0;
        reviews = (result['reviews'] as List)
            .map((e) => RatingModel.fromJson(e))
            .toList();
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Widget buildSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5,
                (index) => Icon(
                  Icons.star,
                  color: index < averageRating.round()
                      ? Colors.amber
                      : Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('$totalRatings Review${totalRatings == 1 ? '' : 's'}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReviewTile(RatingModel review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    review.fullName.isNotEmpty
                        ? review.fullName[0].toUpperCase()
                        : '?',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    review.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 18,
                  color: index < review.rating
                      ? Colors.amber
                      : Colors.grey.shade300,
                ),
              ),
            ),

            if (review.review.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(review.review),
            ],

            const SizedBox(height: 10),

            Text(
              review.createdAt,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReviewsList() {
    if (reviews.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 70, color: Colors.grey),
            SizedBox(height: 10),
            Text('No reviews yet', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadReviews,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSummaryCard(),

          const SizedBox(height: 15),

          const Text(
            'Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...reviews.map(buildReviewTile),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text('${widget.userName} Reviews'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading ? const LoadingWidget() : buildReviewsList(),
    );
  }
}
