import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/home_repo.dart';
import '../../data/models/make_read_all_notifications_model.dart';

@lazySingleton
class MakeReadAllNotificationsUseCase implements UseCase<MakeReadAllNotificationsModel, MakeReadAllNotificationsParams> {

  final HomeRepo home;

  MakeReadAllNotificationsUseCase({required this.home});

  @override
  DataResponse<MakeReadAllNotificationsModel> call(MakeReadAllNotificationsParams params) {
    return home.makeReadAllNotifications(params);
  }
}

class MakeReadAllNotificationsParams with Params{}
