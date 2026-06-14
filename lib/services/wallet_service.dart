import '../utils/api_endpoints.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../services/api_service.dart';
import '../utils/app_session.dart';

class WalletService {
  final ApiService api = ApiService();

  Future<WalletModel?> getWallet() async {
    if (AppSession.userId == null) {
      return null;
    }
    final result = await api.get(
      endpoint: ApiEndpoints.getWallet,
      queryParameters: {'user_id': AppSession.userId.toString()},
    );


    if (result['success'] != true) {
      return null;
    }

    return WalletModel.fromJson(result['wallet']);
  }

  Future<List<WalletTransactionModel>> getTransactions() async {
    if (AppSession.userId == null) {
      return [];
    }

    final result = await api.get(
      endpoint: ApiEndpoints.getWalletTransactions,
      queryParameters: {'user_id': AppSession.userId.toString()},
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['transactions'] as List)
        .map((transaction) => WalletTransactionModel.fromJson(transaction))
        .toList();
  }
}
