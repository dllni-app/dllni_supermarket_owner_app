import 'package:common_package/helpers/typedef.dart';

import '../../data/models/get_low_stock_model.dart';
import '../../data/models/get_products_model.dart';
import '../../data/models/total_producst_count_model.dart';
import '../usecases/get_low_stock_use_case.dart';
import '../usecases/get_products_use_case.dart';
import '../usecases/total_producst_count_use_case.dart';
import '../usecases/get_categories_use_case.dart';
import '../../data/models/get_categories_model.dart';
import '../usecases/get_product_from_image_use_case.dart';
import '../../data/models/get_product_from_image_model.dart';
import '../usecases/get_product_from_text_use_case.dart';
import '../../data/models/get_product_from_text_model.dart';
import '../usecases/add_product_use_case.dart';
import '../../data/models/add_product_model.dart';

abstract class ProductsRepo {
  DataResponse<GetProductsModel> getProducts(GetProductsParams params);

  DataResponse<GetLowStockModel> getLowStock(GetLowStockParams params);

  DataResponse<TotalProducstCountModel> totalProducstCount(
    TotalProductsCountParams params,
  );
  

  DataResponse<GetCategoriesModel> getCategories(GetCategoriesParams params);

  DataResponse<GetProductFromImageModel> getProductFromImage(GetProductFromImageParams params);

  DataResponse<GetProductFromTextModel> getProductFromText(GetProductFromTextParams params);

  DataResponse<AddProductModel> addProduct(AddProductParams params);
}
