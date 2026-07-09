import 'dart:convert';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/themes/app_colors.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  Map<String, dynamic> storeProfile = {};
  @override
  void initState() {
    super.initState();
    storeProfile = jsonDecode(
      SharedPreferencesHelper.getData(key: 'user') as String,
    );
    print(storeProfile);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(
        24,
        26 + MediaQuery.paddingOf(context).top,
        24,
        20,
      ),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      //   border: Border(bottom: BorderSide(width: 2, color: AppColors.accent)),
      //   boxShadow: [
      //     BoxShadow(
      //       offset: Offset(0, 1),
      //       blurRadius: 2,
      //       color: Color(0x0D000000),
      //     ),
      //   ],
      // ),
      child: Row(
        spacing: 12,
        children: [
          Icon(FontAwesomeIcons.store.data, color: context.primary, size: 29),
          AppText(
            storeProfile["user"]['name'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              context.pushRoute("/notification_screen");
            },
            child: Icon(
              FontAwesomeIcons.bell.data,
              color: context.primary,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeAppBarOld extends StatelessWidget {
  final String shopName;
  final String shopAddress;
  const HomeAppBarOld({
    super.key,
    required this.shopName,
    required this.shopAddress,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(
        16,
        16 + MediaQuery.paddingOf(context).top,
        16,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        border: Border(bottom: BorderSide(width: 2, color: AppColors.accent)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color(0x0D000000),
          ),
        ],
      ),
      child: Row(
        spacing: 12,
        children: [
          ProfileImage(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  shopName,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    color: AppColors.accent,
                    fontSize: 18,
                  ),
                ),
                Text(
                  shopAddress,
                  textAlign: TextAlign.center,
                  style: textTheme.labelMedium!.copyWith(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
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

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFC4C4C4),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 2, color: AppColors.white),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Color(0x0D000000),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: AppColors.white),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xFF28C76F),
            ),
          ),
        ),
      ],
    );
  }
}
