import 'package:common_package/helpers/typedef.dart';
import '../usecases/get_products_use_case.dart';
import '../../data/models/get_products_model.dart';
import '../usecases/get_categories_use_case.dart';
import '../../data/models/get_categories_model.dart';
import '../usecases/get_low_stock_use_case.dart';
import '../../data/models/get_low_stock_model.dart';
import '../usecases/total_producst_count_use_case.dart';
import '../../data/models/total_producst_count_model.dart';
abstract class ProductsRepo {
  DataResponse<GetProductsModel> getProducts(GetProductsParams params);

  DataResponse<GetCategoriesModel> getCategories(GetCategoriesParams params);

  DataResponse<GetLowStockModel> getLowStock(GetLowStockParams params);

  DataResponse<TotalProducstCountModel> totalProducstCount(TotalProducstCountParams params);
}
