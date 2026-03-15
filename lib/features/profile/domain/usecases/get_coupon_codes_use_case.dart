import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/get_coupon_codes_model.dart';
import '../repository/profile_repo.dart';

@lazySingleton
class GetCouponCodesUseCase
    implements UseCase<GetCouponCodesModel, GetCouponCodesParams> {
  final ProfileRepo profile;

  GetCouponCodesUseCase({required this.profile});

  @override
  DataResponse<GetCouponCodesModel> call(GetCouponCodesParams params) {
    return profile.getCouponCodes(params);
  }
}

class GetCouponCodesParams with Params {
  final String? search;
  final int storeId;
  final bool? isActive;
  final int page;

  GetCouponCodesParams({
    required this.storeId,
    this.search,
    this.isActive,
    this.page = 1,
  });

  @override
  QueryParams getParams() => {
    if (search != "" && search != null) "filter[search]": search,
    "filter[storeId]": storeId,
    if (isActive != null) "filter[isActive]": isActive! ? 1 : 0,
    "page": page,
  };
}
