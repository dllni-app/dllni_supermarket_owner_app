import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../../view/screens/inventory_screen.dart';
import '../repository/inventory_repo.dart';
import '../../data/models/update_product_amount_model.dart';

@lazySingleton
class UpdateProductAmountUseCase
    implements UseCase<UpdateProductAmountModel, UpdateProductAmountParams> {
  final InventoryRepo inventory;

  UpdateProductAmountUseCase({required this.inventory});

  @override
  DataResponse<UpdateProductAmountModel> call(
    UpdateProductAmountParams params,
  ) {
    return inventory.updateProductAmount(params);
  }
}

class UpdateProductAmountParams with Params {
  final int quantity;
  final EditingType operation;
  final int productId;

  UpdateProductAmountParams({
    required this.productId,
    required this.quantity,
    required this.operation,
  });

  @override
  BodyMap getBody() => {
    "quantity": quantity,
    "operation": operation == EditingType.increment
        ? "INCREMENT"
        : operation == EditingType.decrement
        ? "DECREMENT"
        : "SET",
  };
}
