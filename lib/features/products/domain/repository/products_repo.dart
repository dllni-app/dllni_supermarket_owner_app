import 'package:common_package/helpers/typedef.dart';
import '../usecases/get_all_products_use_case.dart';
import '../../data/models/get_all_products_model.dart';
abstract class ProductsRepo {
  DataResponse<GetAllProductsModel> getAllProducts(GetAllProductsParams params);
}
