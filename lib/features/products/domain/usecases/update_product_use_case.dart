import 'dart:io';

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

  final int? storeId;
  final int? categoryId;
  final int? masterProductId;
  final String? name;
  final String? barcode;
  final String? description;
  final num? price;
  final num? discountedPrice;
  final int? stockQuantity;
  final int? lowStockThreshold;
  final String? expiresAt;
  final bool? isAvailable;
  final Object? image;
  final List<dynamic>? images;

  const UpdateStoreProductBody({
    this.storeId,
    this.categoryId,
    this.masterProductId,
    this.name,
    this.barcode,
    this.description,
    this.price,
    this.discountedPrice,
    this.stockQuantity,
    this.lowStockThreshold,
    this.expiresAt,
    this.isAvailable,
    this.image,
    this.images,
  });

  Map<String, dynamic> toMap() {
    final imgs = images;
    return {
      'storeId': storeId ?? kDefaultStoreId,
      if (categoryId != null) 'categoryId': categoryId,
      if (masterProductId != null) 'masterProductId': masterProductId,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      'sourceType': kSourceTypeManual,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (discountedPrice != null) 'discountedPrice': discountedPrice,
      if (stockQuantity != null) 'stockQuantity': stockQuantity,
      if (lowStockThreshold != null) 'lowStockThreshold': lowStockThreshold,
      if (expiresAt != null) 'expiresAt': expiresAt,
      'isAvailable': isAvailable ?? true,
      if (image is File) 'image': image,
      if (imgs != null && imgs.isNotEmpty) 'images': imgs,
    };
  }
}

class UpdateProductParams with Params {
  final int productId;
  final bool? isActive;
  final UpdateStoreProductBody? fullUpdate;

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
