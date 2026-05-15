import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/get_offer_codes_model.dart';
import '../repository/profile_repo.dart';

@lazySingleton
class GetOfferCodesUseCase
    implements UseCase<GetOfferCodesModel, GetOfferCodesParams> {
  final ProfileRepo profile;

  GetOfferCodesUseCase({required this.profile});

  @override
  DataResponse<GetOfferCodesModel> call(GetOfferCodesParams params) {
    return profile.getOfferCodes(params);
  }
}

class GetOfferCodesParams with Params {
  final int storeId;
  final String? search;
  final bool? isActive;
  final int page;
  final String? sort;
  GetOfferCodesParams({
    required this.storeId,
    this.search,
    this.isActive,
    this.page = 1,
    this.sort,
  });

  @override
  QueryParams getParams() => {
    "filter[storeId]": storeId,
    if (search != null && search != "") "filter[search]": search,
    if (isActive != null) "filter[isActive]": isActive! ? 1 : 0,
    "page": page,
    if (sort != null) "sort": sort,
  };
}
