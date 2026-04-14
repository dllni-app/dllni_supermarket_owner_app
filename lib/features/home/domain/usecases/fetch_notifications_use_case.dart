import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/home_repo.dart';
import '../../data/models/fetch_notifications_model.dart';

@lazySingleton
class FetchNotificationsUseCase
    implements UseCase<FetchNotificationsModel, FetchNotificationsParams> {
  final HomeRepo home;

  FetchNotificationsUseCase({required this.home});

  @override
  DataResponse<FetchNotificationsModel> call(FetchNotificationsParams params) {
    return home.fetchNotifications(params);
  }
}

class FetchNotificationsParams with Params {
  final int page;

  FetchNotificationsParams({this.page = 1});

  @override
  QueryParams getParams() => {"perPage": 10, "page": page};
}
