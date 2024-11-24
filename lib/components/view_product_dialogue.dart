// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/textfield_with_title.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class ViewProductDialogue extends StatefulWidget {
  final ProductModel product;

  ViewProductDialogue({super.key, required this.product});

  @override
  State<ViewProductDialogue> createState() => _ViewProductDialogueState();
}

class _ViewProductDialogueState extends State<ViewProductDialogue> {
  String? selectedCategory;
  DateTime? expiryDate;
  String? selectedImage;
  var productsController = Get.put<ProductsController>(ProductsController());

  final List<String> categories = [
    'Tablets',
    'Syrups',
    'Capsules',
    'Injections',
    'Suppliments',
    'General'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize reactive variables
    productsController.nameController.text = widget.product.name;
    productsController.formulaController.text = widget.product.formula ?? 'N/A';
    productsController.strengthController.text =
        widget.product.strength.toString();
    productsController.barcodeController.text =
        widget.product.barcode.toString();

    productsController.unitPurchasePriceController.text =
        widget.product.isSingleUnit
            ? 'N/A'
            : widget.product.unitPurchasePrice.toString();

    productsController.unitSalePriceController.text =
        widget.product.unitSalePrice.toString();

    productsController.packPurchasePriceController.text =
        widget.product.isSingleUnit
            ? 'N/A'
            : widget.product.packPurchasePrice.toString();

    productsController.packSalePriceController.text =
        widget.product.isSingleUnit
            ? 'N/A'
            : widget.product.packSalePrice.toString();

    productsController.availableUnitsController.text =
        widget.product.availableUnits.toString();
    productsController.availablePacksController.text =
        widget.product.availablePacks.toString();
    productsController.expiryDateController.text = widget.product.expiryDate;
    productsController.batchNumberController.text = widget.product.batchNumber;
    productsController.unitsInPackController.text = widget.product.isSingleUnit
        ? 'N/A'
        : widget.product.unitsInPack.toString();
    productsController.companyController.text = widget.product.company;
    productsController.selectedCategory.value = widget.product.category;
    productsController.isSingleUnit.value = widget.product.isSingleUnit;
    selectedCategory = widget.product.category;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 50,
          ),
          const Text(
            "Update Product",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close),
          )
        ],
      ),
      content: SizedBox(
        width: screenWidth * 0.7,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFieldWithTitle(
                          title: 'Product Title',
                          controller: productsController.nameController,
                          isReadyOnly: true,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Select Category:'),
                            SizedBox(
                              width: screenWidth * 0.22,
                              height: screenHeight * 0.08,
                              child: DropdownButtonFormField<String>(
                                value:
                                    productsController.selectedCategory.value,
                                hint: const Text('Select Category'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                items: categories.map((String category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Is Single Unit'),
                              Container(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.07,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Is Single Unit?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Obx(
                                      () => Checkbox(
                                        value: productsController
                                            .isSingleUnit.value,
                                        onChanged: (bool? value) {},
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        TextFieldWithTitle(
                          title: 'Formula',
                          controller: productsController.formulaController,
                          isReadyOnly: true,
                        ),
                        TextFieldWithTitle(
                          title: 'Strength',
                          controller: productsController.strengthController,
                          isReadyOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldWithTitle(
                          title: 'Batch No',
                          controller: productsController.batchNumberController,
                          isReadyOnly: true,
                        ),
                        TextFieldWithTitle(
                          title: 'Company',
                          controller: productsController.companyController,
                          isReadyOnly: true,
                        ),
                        Obx(
                          () => productsController.isSingleUnit.value
                              ? const SizedBox()
                              : TextFieldWithTitle(
                                  title: 'Units per Pack',
                                  controller:
                                      productsController.unitsInPackController,
                                  isReadyOnly: true,
                                ),
                        ),
                        Obx(
                          () => productsController.isSingleUnit.value
                              ? const SizedBox()
                              : TextFieldWithTitle(
                                  title: 'Available Packs',
                                  controller: productsController
                                      .availablePacksController,
                                  isReadyOnly: true,
                                ),
                        ),
                        TextFieldWithTitle(
                          title: 'Available Units',
                          controller:
                              productsController.availableUnitsController,
                          isReadyOnly: true,
                        ),
                        Obx(
                          () => productsController.isSingleUnit.value
                              ? const SizedBox()
                              : TextFieldWithTitle(
                                  title: 'Pack Purchase Price',
                                  controller: productsController
                                      .packPurchasePriceController,
                                  isReadyOnly: true,
                                ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      TextFieldWithTitle(
                        title: 'Unit Purchase Price',
                        controller:
                            productsController.unitPurchasePriceController,
                        isReadyOnly: true,
                      ),
                      TextFieldWithTitle(
                        title: 'Unit Sale Price',
                        controller: productsController.unitSalePriceController,
                        isReadyOnly: true,
                      ),
                      Obx(
                        () => productsController.isSingleUnit.value
                            ? const SizedBox()
                            : TextFieldWithTitle(
                                title: 'Pack Sale Price',
                                controller:
                                    productsController.packSalePriceController,
                                isReadyOnly: true,
                              ),
                      ),
                      TextFieldWithTitle(
                        title: 'Barcode',
                        controller: productsController.barcodeController,
                        isReadyOnly: true,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Expiry Date'),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.22,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: TextFormField(
                                  controller:
                                      productsController.expiryDateController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    hintText: 'Select Expiry Date',
                                  ),
                                  readOnly: true,
                                )),
                          ]),
                    ],
                  ))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
