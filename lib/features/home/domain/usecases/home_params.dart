import 'package:common_package/helpers/typedef.dart';

class HomeStoreParams with Params {
  final int storeId;

  HomeStoreParams({required this.storeId});

  @override
  QueryParams getParams() => {
        'storeId': storeId.toString(),
      };

  QueryParams getParamsLowStock() => {
        'store_id': storeId.toString(),
      };
}

class HomeOrdersParams with Params {
  final int storeId;
  final String status;

  HomeOrdersParams({required this.storeId, required this.status});

  @override
  QueryParams getParams() => {
        'filter[storeId]': storeId.toString(),
        'filter[status]': status,
      };
}

class HomeOrderActionParams with Params {
  final int orderId;

  HomeOrderActionParams({required this.orderId});
}

class HomeRejectOrderParams with Params {
  final int orderId;
  final String reason;
  final String rejectionType;

  HomeRejectOrderParams({
    required this.orderId,
    required this.reason,
    required this.rejectionType,
  });

  @override
  BodyMap getBody() => {
        'reason': reason,
        'rejectionType': rejectionType,
      };
}
