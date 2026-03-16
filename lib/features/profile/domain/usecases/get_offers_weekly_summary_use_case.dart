import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/get_offers_weekly_summary_model.dart';

@lazySingleton
class GetOffersWeeklySummaryUseCase implements UseCase<GetOffersWeeklySummaryModel, GetOffersWeeklySummaryParams> {

  final ProfileRepo profile;

  GetOffersWeeklySummaryUseCase({required this.profile});

  @override
  DataResponse<GetOffersWeeklySummaryModel> call(GetOffersWeeklySummaryParams params) {
    return profile.getOffersWeeklySummary(params);
  }
}

class GetOffersWeeklySummaryParams with Params{}
