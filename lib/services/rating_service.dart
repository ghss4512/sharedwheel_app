import '../services/api_service.dart';
import '../utils/api_endpoints.dart';

class RatingService {
  final ApiService api = ApiService();

  Future<Map<String, dynamic>> getUserRatings(int userId) async {
    return await api.get(
      endpoint: ApiEndpoints.getUserRatings,
      queryParameters: {'user_id': userId.toString()},
    );
  }

  Future<Map<String, dynamic>> submitRating({
    required int rideId,
    required int reviewerId,
    required int reviewedUserId,
    required int rating,
    String review = '',
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.submitRating,
      data: {
        'ride_id': rideId.toString(),
        'reviewer_id': reviewerId.toString(),
        'reviewed_user_id': reviewedUserId.toString(),
        'rating': rating.toString(),
        'review': review,
      },
    );
  }

  Future<bool> canRate({required int rideId, required int reviewerId, required int reviewedUserId,}) async {
    final result = await api.get(
      endpoint: ApiEndpoints.canRate,
      queryParameters: {
        'ride_id': rideId.toString(),
        'reviewer_id': reviewerId.toString(),
        'reviewed_user_id': reviewedUserId.toString(),
      },
    );
    if (result['success'] != true) {
      return false;
    }
    return result['can_rate'] == true;
  }
}
