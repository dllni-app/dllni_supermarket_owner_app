import 'package:dllni_supermarket_owner_app/features/inventory/view/screens/inventory_screen.dart';
import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/inventory_repo.dart';
import '../../data/models/get_products_model.dart';

@lazySingleton
class GetProductsUseCase
    implements UseCase<GetProductsModel, GetProductsParams> {
  final InventoryRepo inventory;

  GetProductsUseCase({required this.inventory});

  @override
  DataResponse<GetProductsModel> call(GetProductsParams params) {
    return inventory.getProducts(params);
  }
}

class GetProductsParams with Params {}
