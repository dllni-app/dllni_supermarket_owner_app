import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/add_coupon_code_model.dart';

@lazySingleton
class AddCouponCodeUseCase
    implements UseCase<AddCouponCodeModel, AddCouponCodeParams> {
  final ProfileRepo profile;

  AddCouponCodeUseCase({required this.profile});

  @override
  DataResponse<AddCouponCodeModel> call(AddCouponCodeParams params) {
    return profile.addCouponCode(params);
  }
}

class AddCouponCodeParams with Params {
  final AddCouponCodeModelData coupon;
  final int storeId;

  AddCouponCodeParams({required this.coupon, required this.storeId});
  @override
  BodyMap getBody() => {
    "storeId": storeId,
    "code": coupon.code,
    "type": coupon.type,
    "value": coupon.value,
    "percent": coupon.percent,
    "minOrderAmount": coupon.minOrderAmount,
    "maxDiscountAmount": coupon.maxDiscountAmount,
    "usageLimit": coupon.usageLimit,
    "usedCount": coupon.usedCount ?? 0,
    "startsAt": coupon.startsAt,
    "endsAt": coupon.endsAt,
    "isActive": true,
  };
}
