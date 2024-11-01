import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/components/filter_item_widget.dart';
import 'package:pharmacy_pos/components/product_card.dart';
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
    final ProductsDBController productsDbController = Get.find<ProductsDBController>();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Home',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 500,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search an item...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      filtersController.switchSearchingStatus(false);
                      filtersController.updateFilteredProducts(productsDbController.products); // Reset to all products
                    } else {
                      filtersController.switchSearchingStatus(true);
                      filtersController.searchProducts(value, productsDbController.products);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              FilterItemWidget(filterLabel: 'All', filterIcon: Icons.play_circle_fill),
              FilterItemWidget(filterLabel: 'Pills', filterIcon: Icons.play_circle_fill),
              FilterItemWidget(filterLabel: 'Capsules', filterIcon: Icons.play_circle_fill),
              FilterItemWidget(filterLabel: 'Syrups', filterIcon: Icons.play_circle_fill),
              FilterItemWidget(filterLabel: 'Injections', filterIcon: Icons.play_circle_fill),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (filtersController.filteredProducts.isEmpty) {
                return const Center(child: Text('No Products Available'));
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 5,
                ),
                itemCount: filtersController.filteredProducts.length,
                itemBuilder: (context, index) {
                  final ProductModel product = filtersController.filteredProducts[index];
                  return ProductCard(productModel: product);
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
