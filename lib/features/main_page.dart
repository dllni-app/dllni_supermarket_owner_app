import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/widgets/app_nav_bar.dart';
import 'home/view/home_screen.dart';
import 'products/view/screens/products_screen.dart';

@AutoRoutePage(path: "/")
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedTab == 0
          ? HomeScreen()
          : selectedTab == 2
          ? ProductsScreen()
          : Center(child: Text("قيد التطوير")),
      bottomNavigationBar: AppNavBar(
        items: [
          AppNavBarItem(title: "الرئيسية", icon: Icons.home_rounded),
          AppNavBarItem(title: "الطلبات", icon: FontAwesomeIcons.receipt),
          AppNavBarItem(title: "المنتجات", icon: FontAwesomeIcons.carrot),
          AppNavBarItem(title: "المخزون", icon: FontAwesomeIcons.fileInvoice),
          AppNavBarItem(title: "المزيد", icon: Icons.menu),
        ],
        selectedIndex: selectedTab,
        onChanged: (index) {
          if (index != selectedTab) {
            selectedTab = index;
            setState(() {});
          }
        },
      ),
    );
  }
}
