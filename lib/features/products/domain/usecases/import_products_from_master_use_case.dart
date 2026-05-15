import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/import_products_from_master_model.dart';
import '../repository/products_repo.dart';

@lazySingleton
class ImportProductsFromMasterUseCase
    implements
        UseCase<ImportProductsFromMasterModel, ImportProductsFromMasterParams> {
  final ProductsRepo products;

  ImportProductsFromMasterUseCase({required this.products});

  @override
  DataResponse<ImportProductsFromMasterModel> call(
    ImportProductsFromMasterParams params,
  ) {
    return products.importProductsFromMaster(params);
  }
}

class ImportProductsFromMasterParams with Params {
  final List<int> masterProductIds;

  ImportProductsFromMasterParams({required this.masterProductIds});

  @override
  BodyMap getBody() => {'masterProductIds': masterProductIds};
}
