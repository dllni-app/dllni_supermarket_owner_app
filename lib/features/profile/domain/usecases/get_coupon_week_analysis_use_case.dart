import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/get_coupon_week_analysis_model.dart';

@lazySingleton
class GetCouponWeekAnalysisUseCase
    implements
        UseCase<GetCouponWeekAnalysisModel, GetCouponWeekAnalysisParams> {
  final ProfileRepo profile;

  GetCouponWeekAnalysisUseCase({required this.profile});

  @override
  DataResponse<GetCouponWeekAnalysisModel> call(
    GetCouponWeekAnalysisParams params,
  ) {
    return profile.getCouponWeekAnalysis(params);
  }
}

class GetCouponWeekAnalysisParams with Params {
  final int storeId;

  GetCouponWeekAnalysisParams({required this.storeId});
  @override
  QueryParams getParams() => {"storeId": storeId};
}
