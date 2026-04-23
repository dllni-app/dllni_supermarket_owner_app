import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/update_product_model.dart';

@lazySingleton
class UpdateProductUseCase
    implements UseCase<UpdateProductModel, UpdateProductParams> {
  final ProductsRepo products;

  UpdateProductUseCase({required this.products});

  @override
  DataResponse<UpdateProductModel> call(UpdateProductParams params) {
    return products.updateProduct(params);
  }
}

class UpdateStoreProductBody {
  static const int kDefaultStoreId = 1;
  static const String kSourceTypeManual = 'manual';

  final int storeId;
  final int categoryId;
  final int? masterProductId;
  final String name;
  final String? barcode;
  final String? description;
  final num price;
  final num? discountedPrice;
  final int stockQuantity;
  final int lowStockThreshold;
  final String? expiresAt;
  final bool isAvailable;
  final Object? image;
  final List<dynamic> images;

  const UpdateStoreProductBody({
    this.storeId = kDefaultStoreId,
    required this.categoryId,
    this.masterProductId,
    required this.name,
    this.barcode,
    this.description,
    required this.price,
    this.discountedPrice,
    required this.stockQuantity,
    required this.lowStockThreshold,
    this.expiresAt,
    this.isAvailable = true,
    this.image,
    this.images = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'categoryId': categoryId,
      'masterProductId': masterProductId,
      'name': name,
      'barcode': barcode,
      'sourceType': kSourceTypeManual,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'expiresAt': expiresAt,
      'isAvailable': isAvailable,
      'image': image,
      'images': images,
    };
  }
}

class UpdateProductParams with Params {
  final int productId;
  final bool? isActive;
  final UpdateStoreProductBody? fullUpdate;

  /// Product card switch (keeps previous JSON shape for the same endpoint).
  factory UpdateProductParams.toggle({
    required int productId,
    required bool isActive,
  }) {
    return UpdateProductParams._(
      productId: productId,
      isActive: isActive,
      fullUpdate: null,
    );
  }

  /// Full PUT body from the edit form.
  factory UpdateProductParams.form({
    required int productId,
    required UpdateStoreProductBody body,
  }) {
    return UpdateProductParams._(productId: productId, fullUpdate: body);
  }

  UpdateProductParams._({
    required this.productId,
    this.isActive,
    this.fullUpdate,
  });

  @override
  BodyMap getBody() {
    if (fullUpdate != null) {
      return fullUpdate!.toMap();
    }
    return {"isActive": isActive!};
  }
}
