import 'package:common_package/helpers/typedef.dart';

class UpdatePreparationEstimateParams with Params {
  final int orderId;
  final int? preparationTimeMinutes;

  const UpdatePreparationEstimateParams({
    required this.orderId,
    required this.preparationTimeMinutes,
  });

  @override
  BodyMap getBody() => {
        'preparationTimeMinutes': preparationTimeMinutes,
      };
}
