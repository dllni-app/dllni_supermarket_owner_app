import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OffersStatisticsGrid extends StatefulWidget {
  const OffersStatisticsGrid({super.key});

  @override
  State<OffersStatisticsGrid> createState() => _OffersStatisticsGridState();
}

class _OffersStatisticsGridState extends State<OffersStatisticsGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.value = 0.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      'عروض نشطة',
      'عروض مجدولة',
      'عروض منتهية',
      'طلب مستفيد',
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.onPrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 17, vertical: 17),
      margin: EdgeInsetsDirectional.symmetric(horizontal: 24),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffDBEAFE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsetsDirectional.all(10),
                  child: Icon(
                    IconsaxPlusBold.status_up,
                    size: 24,
                    color: context.primary,
                  ),
                ),
                SizedBox(width: 12),
                AppText.bodyMedium(
                  'الإحصائيات',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111827),
                ),
                Spacer(),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xff9CA3AF),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _sizeAnimation,
            axisAlignment: -1.0,
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  spacing: 12,
                  children: List.generate(
                    2,
                    (i) => Expanded(
                      child: StatePointer(
                        title: titles[i],
                        value: 100,
                        containerBorderColor: i == 0
                            ? Color(0xff10B981).withAlpha(51)
                            : Color(0xffF59E0B).withAlpha(51),
                        containerColor: i == 0
                            ? Color(0xff10B981).withAlpha(25)
                            : Color(0xffF59E0B).withAlpha(25),
                        icon: i == 0
                            ? FontAwesomeIcons.solidClock
                            : Icons.watch_later,
                        iconCardColor: i == 0
                            ? Color(0xff10B981).withAlpha(51)
                            : Color(0xffF59E0B).withAlpha(51),
                        iconColor: i == 0
                            ? Color(0xff10B981)
                            : Color(0xffF59E0B),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  spacing: 12,
                  children: List.generate(
                    2,
                    (i) => Expanded(
                      child: StatePointer(
                        title: titles[i + 2],
                        value: 100,
                        containerBorderColor: i == 0
                            ? Color(0xffE5E7EB)
                            : Color(0xff064E3B).withAlpha(51),
                        containerColor: i == 0
                            ? Color(0xffF3F4F6)
                            : Color(0xff064E3B).withAlpha(25),
                        icon: i == 0 ? Icons.block : FontAwesomeIcons.receipt,
                        iconCardColor: i == 0
                            ? Color(0xffE5E7EB)
                            : Color(0xff064E3B).withAlpha(51),
                        iconColor: i == 0
                            ? Color(0xff6B7280)
                            : Color(0xff064E3B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatePointer extends StatelessWidget {
  const StatePointer({
    super.key,
    required this.title,
    required this.value,
    required this.containerColor,
    required this.containerBorderColor,
    required this.iconCardColor,
    required this.iconColor,
    required this.icon,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color containerColor;
  final Color containerBorderColor;
  final Color iconCardColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: containerBorderColor),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 15,
            color: Color(0x07000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: iconCardColor,
            ),
            padding: EdgeInsetsDirectional.all(11),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.displaySmall(
                  value.toString(),
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 2),
                AppText.labelMedium(
                  title,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
