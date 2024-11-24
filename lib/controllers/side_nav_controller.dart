// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/screens/analytics_screen.dart';
import 'package:pharmacy_pos/screens/expiry_screen.dart';
import 'package:pharmacy_pos/screens/orders_screen.dart';
import 'package:pharmacy_pos/screens/home_screen.dart';
import 'package:pharmacy_pos/screens/products_screen.dart';
import 'package:pharmacy_pos/screens/sales_screen.dart';
import 'package:pharmacy_pos/screens/settings_screen.dart';
import 'package:pharmacy_pos/screens/stock_screen.dart';

class SideNavController extends GetxController {
  final RxString _selectedItemLabel = "Home".obs;
  RxString get selectedItemLabel => _selectedItemLabel;

  final RxInt _selectedPageIndex = 0.obs;
  int get selectedPageIndex => _selectedPageIndex.value;

  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  @override
  void onClose() {
    _pageController.dispose();
    super.onClose();
  }

  void changeSelectedLabel(String label) {
    _selectedItemLabel.value = label;

    switch (label) {
      case 'Home':
        _selectedPageIndex.value = 0;
        break;
      case 'Orders':
        _selectedPageIndex.value = 1;
        break;
      case 'Products':
        _selectedPageIndex.value = 2;
        break;
      case 'Stock':
        _selectedPageIndex.value = 3;
      case 'Sales':
        _selectedPageIndex.value = 4;
        break;
      case 'Expiry':
        _selectedPageIndex.value = 5;
        break;
      case 'Analytics':
        _selectedPageIndex.value = 6;
        break;
    }

    _pageController.animateToPage(
      _selectedPageIndex.value,
      duration: Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  String _getLabelByIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Orders';
      case 2:
        return 'Products';
      case 3:
        return 'Stock';
      case 4:
        return 'Sales';
      case 5:
        return 'Expiry';
      case 6:
        return 'Analytics';
      default:
        return 'Home';
    }
  }

  List<Widget> screensList = [
    HomeScreen(),
    OrdersScreen(),
    ProductsScreen(),
    StockScreen(),
    SalesScreen(),
    ExpiryScreen(),
    AnalyticsScreen(),
  ].obs;

  SideNavController() {
    _pageController.addListener(() {
      _selectedPageIndex.value = _pageController.page!.round();
      _selectedItemLabel.value = _getLabelByIndex(_selectedPageIndex.value);
    });
  }
}
