// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/components/filter_item_widget.dart';
import 'package:pharmacy_pos/controllers/filter_controller.dart';
import 'package:pharmacy_pos/database/products_db_helper.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FiltersController());
    Get.put(ProductsDBController());
    final FiltersController filtersController = Get.find<FiltersController>();
    final ProductsDBController productsDbController =
        Get.find<ProductsDBController>();
    return Container(
        padding: EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 500,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search an item...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                FilterItemWidget(
                  filterLabel: 'All',
                  filterIcon: Icons.play_circle_fill,
                ),
                FilterItemWidget(
                  filterLabel: 'Pills',
                  filterIcon: Icons.play_circle_fill,
                ),
                FilterItemWidget(
                  filterLabel: 'Capsules',
                  filterIcon: Icons.play_circle_fill,
                ),
                FilterItemWidget(
                  filterLabel: 'Syrups',
                  filterIcon: Icons.play_circle_fill,
                ),
                FilterItemWidget(
                  filterLabel: 'Injections',
                  filterIcon: Icons.play_circle_fill,
                ),
              ],
            ),
            Expanded(child: Obx(() {
              List<ProductModel> productsList =
                  productsDbController.products;
              return filtersController
                      .getFilteredProducts(productsList)
                      .isEmpty
                  ? Center(
                      child: Text('No Products Yet'),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: filtersController
                          .getFilteredProducts(productsList)
                          .length,
                      itemBuilder: (context, index) {
                        final ProductModel product =
                            filtersController.getFilteredProducts(
                                productsList)[index];
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.5,
                                ),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.asset(
                                  width: 150,
                                  'assets/images/blister-pack.png',
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.formula,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.unitPrice.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
            }))
          ],
        ));
  }
}
