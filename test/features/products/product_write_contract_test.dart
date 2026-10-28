import 'dart:io';

import 'package:dllni_supermarket_owner_app/features/products/domain/usecases/add_product_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/products/domain/usecases/update_product_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/screens/add_product_details_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('product write request contracts', () {
    test('multipart update is detected when the main image is a file', () {
      final params = UpdateProductParams.form(
        productId: 10,
        body: UpdateStoreProductBody(
          name: 'Updated product',
          price: 600,
          stockQuantity: 500,
          lowStockThreshold: 50,
          image: File('/tmp/product.jpg'),
        ),
      );

      expect(params.requiresMultipartMethodOverride, isTrue);
      expect(params.getBody()['name'], 'Updated product');
      expect(params.getBody()['price'], 600);
      expect(params.getBody()['stockQuantity'], 500);
      expect(params.getBody()['lowStockThreshold'], 50);
    });

    test('json-only update keeps regular PUT path', () {
      final params = UpdateProductParams.form(
        productId: 10,
        body: const UpdateStoreProductBody(
          name: 'Updated product',
          price: 600,
          stockQuantity: 500,
          lowStockThreshold: 50,
        ),
      );

      expect(params.requiresMultipartMethodOverride, isFalse);
    });


    test('manual create sends base price without hidden discount', () {
      final params = AddProductParams(
        params: AddProductDetailsParams(
          title: 'منتج جديد',
          categoryId: 1,
          masterProductId: 2,
          mainImagePath: '/tmp/main.jpg',
          quantity: 10,
          lowStockQuantity: 2,
          price: 1000,
          discountedPrice: 800, // legacy/catalog value must not be resent
        ),
      );
      final body = params.getBody();
      expect(body['price'], 1000);
      expect(body.containsKey('discountedPrice'), isFalse);
    });

    test('manual edit preserves existing discount without resending it', () {
      final form = AddProductDetailsParams(
        title: 'منتج حالي',
        categoryId: 1,
        masterProductId: 2,
        price: 1500,
        discountedPrice: 800, // existing discount not editable in this form
        quantity: 10,
        lowStockQuantity: 2,
      );
      final body = buildUpdateStoreProductBody(form).toMap();
      expect(body['price'], 1500);
      expect(body.containsKey('discountedPrice'), isFalse);
    });

    test('create request includes additional image files', () {
      final params = AddProductParams(
        params: AddProductDetailsParams(
          title: 'New product',
          categoryId: 1,
          masterProductId: 2,
          mainImagePath: '/tmp/main.jpg',
          additionalImagesPath: const [
            '/tmp/extra-1.jpg',
            '/tmp/extra-2.jpg',
          ],
          quantity: 10,
          lowStockQuantity: 2,
          price: 100,
        ),
      );

      final body = params.getBody();
      expect(body['image'], isA<File>());
      expect(body['images'], isA<List<File>>());
      expect((body['images'] as List).length, 2);
    });
  });
}
