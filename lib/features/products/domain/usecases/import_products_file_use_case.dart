import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/import_products_file_model.dart';

@lazySingleton
class ImportProductsFileUseCase
    implements UseCase<ImportProductsFileModel, ImportProductsFileParams> {
  final ProductsRepo products;

  ImportProductsFileUseCase({required this.products});

  @override
  DataResponse<ImportProductsFileModel> call(ImportProductsFileParams params) {
    return products.importProductsFile(params);
  }
}

class ImportProductsFileParams with Params {
  final int categoryId;
  final String filePath;

  ImportProductsFileParams({
    required this.categoryId,
    required this.filePath,
  });

  @override
  BodyMap getBody() => {
    // storeId is intentionally omitted. InjectStoreIdFromOwnerContext on the
    // backend resolves the authenticated seller's store and injects it before
    // request validation, preventing imports into another store.
    'categoryId': categoryId,
    'file': File(filePath),
  };
}
