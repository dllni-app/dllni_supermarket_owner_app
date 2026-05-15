import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/home_repo.dart';
import '../../data/models/get_daily_count_model.dart';

@lazySingleton
class GetDailyCountUseCase implements UseCase<GetDailyCountModel, GetDailyCountParams> {

  final HomeRepo home;

  GetDailyCountUseCase({required this.home});

  @override
  DataResponse<GetDailyCountModel> call(GetDailyCountParams params) {
    return home.getDailyCount(params);
  }
}

class GetDailyCountParams with Params{}
