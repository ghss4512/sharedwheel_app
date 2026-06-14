import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/rating_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class SubmitRatingScreen extends StatefulWidget {
  final int rideId;
  final int reviewedUserId;
  final String userName;

  const SubmitRatingScreen({
    super.key,
    required this.rideId,
    required this.reviewedUserId,
    required this.userName,
  });

  @override
  State<SubmitRatingScreen> createState() => _SubmitRatingScreenState();
}

class _SubmitRatingScreenState extends State<SubmitRatingScreen> {
  final RatingService ratingService = RatingService();

  final TextEditingController reviewController = TextEditingController();

  int selectedRating = 5;

  bool isSubmitting = false;

  Future<void> submitRating() async {
    if (AppSession.userId == null) {
      Functions.error(context, 'User not found.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final result = await ratingService.submitRating(
        rideId: widget.rideId,
        reviewerId: AppSession.userId!,
        reviewedUserId: widget.reviewedUserId,
        rating: selectedRating,
        review: reviewController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        Navigator.pop(context, true);
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;

      Functions.error(context, 'Unable to submit rating.');
    }

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Submit Rating'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isSubmitting
          ? const LoadingWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primary,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            widget.userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final star = index + 1;

                              return IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedRating = star;
                                  });
                                },
                                icon: Icon(
                                  Icons.star,
                                  size: 40,
                                  color: star <= selectedRating
                                      ? Colors.amber
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ),

                          Text(
                            '$selectedRating Star${selectedRating > 1 ? 's' : ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: reviewController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Review (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  PrimaryButton(text: 'Submit Rating', onPressed: submitRating),
                ],
              ),
            ),
    );
  }
}