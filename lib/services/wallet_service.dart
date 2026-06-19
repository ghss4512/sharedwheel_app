import '../models/deposit_request_model.dart';
import '../models/payment_settings_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../models/withdrawal_request_model.dart';
import '../services/api_service.dart';
import '../utils/api_endpoints.dart';
import '../utils/app_session.dart';

class WalletService {
  final ApiService api = ApiService();

  Future<WalletModel> getWallet() async {
    final result = await api.get(
      endpoint: '${ApiEndpoints.getWallet}?user_id=${AppSession.userId}',
    );

    if (result['success'] == true) {
      return WalletModel.fromJson(result);
    }

    return WalletModel(balance: 0);
  }

  Future<List<WalletTransactionModel>> getTransactions() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.getWalletTransactions}?user_id=${AppSession.userId}',
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['transactions'] as List)
        .map((e) => WalletTransactionModel.fromJson(e))
        .toList();
  }

  Future<dynamic> submitDepositRequest({
    required double amount,
    required String method,
    required String referenceNo,
    String remarks = '',
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.submitDepositRequest,
      data: {
        'user_id': AppSession.userId.toString(),
        'amount': amount.toString(),
        'method': method,
        'reference_no': referenceNo,
        'remarks': remarks,
      },
    );
  }

  Future<PaymentSettingsModel?> getPaymentSettings() async {
    final result = await api.get(endpoint: ApiEndpoints.paymentSettings);

    if (result['success'] != true) {
      return null;
    }

    return PaymentSettingsModel.fromJson(result['settings']);
  }

  Future<List<DepositRequestModel>> getDepositRequests() async {
    final result = await api.get(
      endpoint:
          '${ApiEndpoints.myDepositRequests}?user_id=${AppSession.userId}',
    );

    if (result['success'] != true) {
      return [];
    }
    return (result['requests'] as List)
        .map((e) => DepositRequestModel.fromJson(e))
        .toList();
  }

  Future<dynamic> submitWithdrawRequest({
    required double amount,
    required String method,
    required String accountTitle,
    required String accountNumber,
    String remarks = '',
  }) async {
    return await api.post(
      endpoint: ApiEndpoints.submitWithdrawRequest,
      data: {
        'user_id': AppSession.userId.toString(),
        'amount': amount.toString(),
        'method': method,
        'account_title': accountTitle,
        'account_number': accountNumber,
        'remarks': remarks,
      },
    );
  }

  Future<List<WithdrawalRequestModel>> getWithdrawRequests() async {
    final result = await api.get(
      endpoint: '${ApiEndpoints.myWithdrawRequests}?user_id=${AppSession.userId}',
    );

    if (result['success'] != true) {
      return [];
    }

    return (result['requests'] as List)
        .map((e) => WithdrawalRequestModel.fromJson(e))
        .toList();
  }
}
