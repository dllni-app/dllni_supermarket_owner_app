import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/error_handler.dart';

import '../../domain/repository/inventory_repo.dart';

@LazySingleton(as: InventoryRepo)
class InventoryRepoImpl with HandlingException implements InventoryRepo {}

