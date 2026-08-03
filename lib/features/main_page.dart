import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/helpers/seller_permission_access.dart';
import '../core/widgets/app_nav_bar.dart';
import 'home/view/screens/home_screen.dart';
import 'inventory/view/screens/inventory_screen.dart';
import 'orders/view/screens/orders_screen.dart';
import 'products/view/screens/products_screen.dart';
import 'profile/view/screens/more_screen.dart';

@AutoRoutePage(path: "/")
class MainPage extends StatefulWidget {
  final int? initialPage;

  const MainPage({super.key, this.initialPage});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0;
  late final TabController tabController;
  late final List<_MainTab> tabs;

  @override
  void initState() {
    super.initState();

    final access = SellerPermissionAccess.current();
    tabs = [
      _MainTab(
        originalIndex: 0,
        title: 'الرئيسية',
        icon: FontAwesomeIcons.solidHouse.data,
        screen: HomeScreen(),
      ),
      if (access.can(SupermarketPermissionCodes.orders))
        _MainTab(
          originalIndex: 1,
          title: 'الطلبات',
          icon: FontAwesomeIcons.receipt.data,
          screen: OrdersScreen(),
        ),
      if (access.can(SupermarketPermissionCodes.products))
        _MainTab(
          originalIndex: 2,
          title: 'المنتجات',
          icon: FontAwesomeIcons.cubes.data,
          screen: ProductsScreen(),
        ),
      if (access.can(SupermarketPermissionCodes.warehouse))
        _MainTab(
          originalIndex: 3,
          title: 'المخزون',
          icon: FontAwesomeIcons.boxesStacked.data,
          screen: InventoryScreen(),
        ),
      _MainTab(
        originalIndex: 4,
        title: 'المزيد',
        icon: FontAwesomeIcons.bars.data,
        screen: MoreScreen(),
      ),
    ];

    final requestedIndex = widget.initialPage ?? 0;
    final permittedIndex = tabs.indexWhere(
      (tab) => tab.originalIndex == requestedIndex,
    );
    selectedTab = permittedIndex < 0 ? 0 : permittedIndex;

    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: selectedTab,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: tabs.map((tab) => tab.screen).toList(growable: false),
      ),
      bottomNavigationBar: AppNavBar(
        items: tabs
            .map(
              (tab) => AppNavBarItem(title: tab.title, icon: tab.icon),
            )
            .toList(growable: false),
        selectedIndex: selectedTab,
        onChanged: (index) {
          if (index == selectedTab) return;

          setState(() {
            selectedTab = index;
          });
          tabController.animateTo(selectedTab);
        },
      ),
    );
  }
}

class _MainTab {
  const _MainTab({
    required this.originalIndex,
    required this.title,
    required this.icon,
    required this.screen,
  });

  final int originalIndex;
  final String title;
  final IconData icon;
  final Widget screen;
}
