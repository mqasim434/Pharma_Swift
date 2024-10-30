import 'package:get/get.dart';
import 'package:pharmacy_pos/models/product_model.dart';

class FiltersController extends GetxController {
  // Using RxString for reactive updates
  RxString selectedLabel = "Pills".obs;
  var filteredProducts = [].obs;

  // Method to change the label
  void changeLabel(String label) {
    selectedLabel.value = label;
  }

  List<ProductModel> getFilteredProducts(List<ProductModel> products) {
    if (selectedLabel.value == 'All') {
      return products;
    } else {
      return products
          .where((element) => element.type == selectedLabel.value)
          .toList();
    }
  }
}
