import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/get_offers_weekly_summary_model.dart';
import '../repository/profile_repo.dart';

@lazySingleton
class GetOffersWeeklySummaryUseCase
    implements
        UseCase<GetOffersWeeklySummaryModel, GetOffersWeeklySummaryParams> {
  final ProfileRepo profile;

  GetOffersWeeklySummaryUseCase({required this.profile});

  @override
  DataResponse<GetOffersWeeklySummaryModel> call(
    GetOffersWeeklySummaryParams params,
  ) {
    return profile.getOffersWeeklySummary(params);
  }
}

class GetOffersWeeklySummaryParams with Params {
  final int storeId;

  GetOffersWeeklySummaryParams({required this.storeId});

  @override
  BodyMap getParams() => {"storeId": storeId};
}
