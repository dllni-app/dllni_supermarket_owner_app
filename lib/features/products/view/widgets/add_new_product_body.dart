import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import 'add_product_way_card.dart';

class AddNewProductBody extends StatelessWidget {
  const AddNewProductBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          AppText(
            "اختر الطريقة المناسبة لإضافة منتجك",
            style: TextStyle(color: AppColors.secondary, fontSize: 16),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 16,
              children: [
                AddProductWayCard(
                  onTap: () {
                    context.pushRoute("/products/new_product/ai");
                  },
                  backgroundColor: Color(0xFFFAF5FF),
                  foregroundColor: Color(0xFF9333EA),
                  icon: FontAwesomeIcons.wandMagicSparkles,
                  title: "إضافة باستخدام الذكاء الاصطناعي",
                  subtitle:
                      "اكتب اسم الوجبة وسيتم اقتراح الصورة والوصف تلقائياً",
                  hint: "الأسرع",
                ),
                AddProductWayCard(
                  onTap: () {},
                  backgroundColor: Color(0xFFEFF6FF),
                  foregroundColor: Color(0xFF2563EB),
                  icon: FontAwesomeIcons.camera,
                  title: "البحث في الكتالوج المركزي",
                  subtitle: "ارفع صورة المنيو ليتم استخراج المنتجات تلقائياً",
                  hint: "موصى بها",
                ),
                AddProductWayCard(
                  onTap: () {},
                  backgroundColor: Color(0xFFF0FDF4),
                  foregroundColor: Color(0xFF16A34A),
                  icon: FontAwesomeIcons.listCheck,
                  title: "اختيار من قائمة جاهزة",
                  subtitle: "أضف من الوجبات الرائجة مع إمكانية التعديل",
                ),
                AddProductWayCard(
                  onTap: () {},
                  backgroundColor: Color(0xFFFFF7ED),
                  foregroundColor: Color(0xFFEA580C),
                  icon: FontAwesomeIcons.solidFileExcel,
                  title: "رفع ملف Excel أو CSV",
                  subtitle: "استيراد عدة منتجات دفعة واحدة عبر ملف",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
