import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/add_offer_model.dart';

@lazySingleton
class AddOfferUseCase implements UseCase<AddOfferModel, AddOfferParams> {
  final ProfileRepo profile;

  AddOfferUseCase({required this.profile});

  @override
  DataResponse<AddOfferModel> call(AddOfferParams params) {
    return profile.addOffer(params);
  }
}

class AddOfferParams with Params {
  final int storeId;
  final AddOfferModelData offer;
  final List<int> selectedProducts;

  AddOfferParams({
    required this.storeId,
    required this.offer,
    required this.selectedProducts,
  });

  @override
  BodyMap getBody() => {
    "storeId": storeId,
    "name": offer.name,
    "description": offer.description,
    "offerType": offer.offerType,
    "discountValue": num.tryParse(offer.discountValue ?? ""),
    "discountPercent": offer.discountPercent,
    "startsAt": offer.startsAt,
    "endsAt": offer.endsAt,
    "isActive": offer.isActive,
    "offerProducts": selectedProducts
        .map<Map<String, int>>((productId) => {"productId": productId})
        .toList(),
  };
}
