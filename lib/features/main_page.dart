import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/widgets/app_nav_bar.dart';
import 'home/view/screens/home_screen.dart';
import 'inventory/view/screens/inventory_screen.dart';
import 'orders/view/screens/orders_screen.dart';
import 'products/view/screens/products_screen.dart';
import 'profile/view/screens/more_screen.dart';

@AutoRoutePage(path: "/")
class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialPage});
  final int? initialPage;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    if (widget.initialPage != null) selectedTab = widget.initialPage!;
    tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: selectedTab,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeScreen(),
          OrdersScreen(),
          ProductsScreen(),
          InventoryScreen(),
          MoreScreen(),
        ],
      ),
      bottomNavigationBar: AppNavBar(
        items: [
          AppNavBarItem(title: "الرئيسية", icon: FontAwesomeIcons.solidHouse),
          AppNavBarItem(title: "الطلبات", icon: FontAwesomeIcons.receipt),
          AppNavBarItem(title: "المنتجات", icon: FontAwesomeIcons.cubes),
          AppNavBarItem(title: "المخزون", icon: FontAwesomeIcons.boxesStacked),
          AppNavBarItem(title: "المزيد", icon: FontAwesomeIcons.bars),
        ],
        selectedIndex: selectedTab,
        onChanged: (index) {
          if (index != selectedTab) {
            selectedTab = index;
            setState(() {});
            tabController.animateTo(selectedTab);
          }
        },
      ),
    );
  }
}
