import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_buttons.dart';
import '../widgets/basic_info_card.dart';
import '../widgets/communication_info_card.dart';
import '../widgets/location_info_card.dart';
import '../widgets/profile_app_bar.dart';

@AutoRoutePage(path: "/profile")
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileAppBar(),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 19),
                child: Column(
                  children: [
                    BasicInfoCard(),
                    SizedBox(height: 16),
                    LocationInfoCard(),
                    SizedBox(height: 16),
                    CommunicationInfoCard(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: AppButton(
                      title: "حفظ التغييرات",
                      onTap: () {
                        print("accept");
                      },
                    ),
                  ),
                  AppOutlinedButton(
                    title: "إلغاء",
                    color: const Color(0xFFFF4C51),
                    onTap: () {
                      print("Reject");
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16 + context.padding.bottom),
          ],
        ),
      ),
    );
  }
}
