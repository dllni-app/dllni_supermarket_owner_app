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
  final int storeId;
  final String filePath;

  ImportProductsFileParams({
    required this.categoryId,
    required this.storeId,
    required this.filePath,
  });
  @override
  BodyMap getBody() => {
    "storeId": storeId,
    "categoryId": categoryId,
    "file": File(filePath),
  };
}
