import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/get_store_employees_model.dart';

@lazySingleton
class GetStoreEmployeesUseCase
    implements UseCase<GetStoreEmployeesModel, GetStoreEmployeesParams> {
  final ProfileRepo profile;

  GetStoreEmployeesUseCase({required this.profile});

  @override
  DataResponse<GetStoreEmployeesModel> call(GetStoreEmployeesParams params) {
    return profile.getStoreEmployees(params);
  }
}

class GetStoreEmployeesParams with Params {
  final int storeId;
  final String? search;

  GetStoreEmployeesParams({required this.storeId, this.search});

  @override
  QueryParams getParams() => {
    "storeId": storeId,
    if (search != null && search != "") "filter[search]": search,
  };
}
