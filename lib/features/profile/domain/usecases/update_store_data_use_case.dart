import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../../view/screens/profile_screen.dart';
import '../repository/profile_repo.dart';
import '../../data/models/update_store_data_model.dart';

@lazySingleton
class UpdateStoreDataUseCase
    implements UseCase<UpdateStoreDataModel, UpdateStoreDataParams> {
  final ProfileRepo profile;

  UpdateStoreDataUseCase({required this.profile});

  @override
  DataResponse<UpdateStoreDataModel> call(UpdateStoreDataParams params) {
    return profile.updateStoreData(params);
  }
}

class UpdateStoreDataParams with Params {
  final ProfileParams params;

  UpdateStoreDataParams({required this.params});
  @override
  BodyMap getBody() => {
    // "ownerUserId": 1,
    "name": params.storeName,
    // "slug": "string",
    "description": params.description,
    "address": params.address,
    "latitude": params.lat,
    "longitude": params.long,
    "phone": params.phone,
    "city": params.city,
    "neighborhood": params.town,
    // "email": "user@example.com",
    // "averageRating": 0,
    // "totalReviews": 0,
    // "trustScore": 0,
    // "warningCount": 0,
    // "isActive": true,
    // "isFeatured": true,
    // "suspensionUntil": "2019-08-24T14:15:22Z",
    "logo": params.logo64Based,
    "cover": params.cover64Based,
  };
}
