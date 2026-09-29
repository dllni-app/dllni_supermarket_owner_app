import 'package:common_package/helpers/dio_network.dart';
import 'package:dio/dio.dart';

class StoreOwnerOperationException implements Exception {
  final String message;

  const StoreOwnerOperationException(this.message);

  @override
  String toString() => message;
}

/// Thin, authenticated operations client for supermarket-owner actions that are
/// intentionally shared across several feature screens.
///
/// The server still owns authorization, store scoping, validation, lifecycle
/// transitions, inventory rules, and financial calculations.
class StoreOwnerOperationsService {
  final DioNetwork _network;

  StoreOwnerOperationsService(this._network);

  Future<Map<String, dynamic>> cancelOrder({
    required int orderId,
    required String reason,
  }) {
    return _request(
      () => _network.postData(
        endPoint: '/api/v1/store-owner/orders/$orderId/cancel',
        data: {'reason': reason},
      ),
    );
  }

  Future<Map<String, dynamic>> returnOrder({
    required int orderId,
    required List<Map<String, dynamic>> items,
    required String reason,
  }) {
    return _request(
      () => _network.postData(
        endPoint: '/api/v1/store-owner/orders/$orderId/return',
        data: {'items': items, 'reason': reason},
      ),
    );
  }

  Future<Map<String, dynamic>> auditInventory({
    required List<Map<String, dynamic>> products,
  }) {
    return _request(
      () => _network.postData(
        endPoint: '/api/v1/store-owner/inventory/audit',
        data: {'products': products},
      ),
    );
  }

  Future<Map<String, dynamic>> updateExpiration({
    required int productId,
    required DateTime expiresAt,
  }) {
    return _request(
      () => _network.putData(
        endPoint: '/api/v1/store-owner/products/$productId/expiration',
        data: {'expires_at': expiresAt.toIso8601String()},
      ),
    );
  }

  Future<Map<String, dynamic>> getLostOpportunities() {
    return _request(
      () => _network.getData(
        endPoint: '/api/v1/store-owner/reports/lost-opportunities',
      ),
    );
  }

  Future<Map<String, dynamic>> updateOffer({
    required int offerId,
    required Map<String, dynamic> body,
  }) {
    return _request(
      () => _network.patchData(
        endPoint: '/api/v1/sm-offers/$offerId',
        data: body,
      ),
    );
  }

  Future<Map<String, dynamic>> deleteOffer(int offerId) {
    return _request(
      () => _network.deleteData(endPoint: '/api/v1/sm-offers/$offerId'),
    );
  }

  Future<Map<String, dynamic>> updateCoupon({
    required int couponId,
    required Map<String, dynamic> body,
  }) {
    return _request(
      () => _network.patchData(
        endPoint: '/api/v1/sm-coupons/$couponId',
        data: body,
      ),
    );
  }

  Future<Map<String, dynamic>> deleteCoupon(int couponId) {
    return _request(
      () => _network.deleteData(endPoint: '/api/v1/sm-coupons/$couponId'),
    );
  }

  Future<Map<String, dynamic>> updateEmployeeStatus({
    required int staffId,
    required bool isActive,
  }) {
    return _request(
      () => _network.patchData(
        endPoint: '/api/v1/store-owner/employees/$staffId/status',
        data: {'isActive': isActive},
      ),
    );
  }

  Future<Map<String, dynamic>> updateProductOptions({
    required int productId,
    required List<Map<String, dynamic>> options,
  }) {
    return _request(
      () => _network.putData(
        endPoint: '/api/v1/store-owner/products/$productId/options',
        data: {'options': options},
      ),
    );
  }

  Future<Map<String, dynamic>> _request(
    Future<Response<dynamic>> Function() call,
  ) async {
    try {
      final response = await call();
      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        throw StoreOwnerOperationException(_message(response.data));
      }

      final data = response.data;
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return <String, dynamic>{};
    } on DioException catch (error) {
      throw StoreOwnerOperationException(_message(error.response?.data));
    }
  }

  String _message(dynamic data) {
    if (data is Map && data['message'] != null) {
      final message = data['message'].toString().trim();
      if (message.isNotEmpty) return message;
    }
    return 'تعذر تنفيذ العملية. حاول مرة أخرى.';
  }
}
