// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/textfield_with_title.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class UpdateProductDialogue extends StatefulWidget {
  final ProductModel product;

  UpdateProductDialogue({super.key, required this.product});

  @override
  State<UpdateProductDialogue> createState() => _UpdateProductDialogueState();
}

class _UpdateProductDialogueState extends State<UpdateProductDialogue> {
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
        widget.product.unitPurchasePrice.toString();

    productsController.unitSalePriceController.text =
        widget.product.unitSalePrice.toString();

    productsController.packPurchasePriceController.text =
        widget.product.packPurchasePrice.toString();

    productsController.packSalePriceController.text =
        widget.product.packSalePrice.toString();

    productsController.marginController.text = widget.product.margin.toString();
    productsController.gstController.text = widget.product.gst.toString();
    productsController.packPurchaseGSTIncludedController.text =
        widget.product.packPurchaseGSTIncluded.toString();

    productsController.availableUnitsController.text =
        widget.product.availableUnits.toString();
    productsController.availablePacksController.text =
        widget.product.availablePacks.toString();
    productsController.expiryDateController.text = widget.product.expiryDate;
    productsController.batchNumberController.text = widget.product.batchNumber;
    productsController.unitsInPackController.text =
        widget.product.unitsInPack.toString();
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
              productsController.clearFields();
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
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Select Category:'),
                            SizedBox(
                              width: screenWidth * 0.22,
                              height: screenHeight * 0.08,
                              child: DropdownButtonFormField<String>(
                                value:
                                    productsController.selectedCategory.value,
                                hint: Text('Select Category'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                items: categories.map((String category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  productsController.selectedCategory.value =
                                      value.toString();
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Is Single Unit'),
                              Container(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.07,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Is Single Unit?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Obx(
                                      () => Checkbox(
                                        value: productsController
                                            .isSingleUnit.value,
                                        onChanged: (bool? value) {
                                          if (value != null) {
                                            productsController
                                                .isSingleUnit.value = value;
                                          }
                                        },
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
                        ),
                        TextFieldWithTitle(
                          title: 'Strength',
                          controller: productsController.strengthController,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldWithTitle(
                            title: 'Batch No',
                            controller:
                                productsController.batchNumberController,
                          ),
                          TextFieldWithTitle(
                            title: 'Company',
                            controller: productsController.companyController,
                          ),
                          productsController.isSingleUnit.value
                              ? SizedBox()
                              : TextFieldWithTitle(
                                  title: 'Units per Pack',
                                  controller:
                                      productsController.unitsInPackController,
                                  onChange: (value) {
                                    if (productsController
                                            .availablePacksController
                                            .text
                                            .isNotEmpty &&
                                        productsController.unitsInPackController
                                            .text.isNotEmpty) {
                                      double unitPerPack = double.tryParse(
                                              productsController
                                                  .unitsInPackController
                                                  .text) ??
                                          0.0;
                                      double availablePacks = double.tryParse(
                                              productsController
                                                  .availablePacksController
                                                  .text) ??
                                          0.0;
                                      productsController
                                              .availableUnitsController.text =
                                          (unitPerPack * availablePacks)
                                              .toString();
                                    }
                                    if (productsController
                                            .packPurchasePriceController
                                            .text
                                            .isNotEmpty &&
                                        productsController.unitsInPackController
                                            .text.isNotEmpty) {
                                      double packPurchasePrice =
                                          double.tryParse(productsController
                                                  .packPurchasePriceController
                                                  .text) ??
                                              0.0;
                                      double unitInPack = double.tryParse(
                                              productsController
                                                  .unitsInPackController
                                                  .text) ??
                                          0.0;
                                      productsController
                                              .unitPurchasePriceController
                                              .text =
                                          (packPurchasePrice / unitInPack)
                                              .toString();
                                    }
                                    if (productsController
                                            .packSalePriceController
                                            .text
                                            .isNotEmpty &&
                                        productsController.unitsInPackController
                                            .text.isNotEmpty) {
                                      double packSalePrice = double.tryParse(
                                              productsController
                                                  .packSalePriceController
                                                  .text) ??
                                          0.0;
                                      double unitInPack = double.tryParse(
                                              productsController
                                                  .unitsInPackController
                                                  .text) ??
                                          0.0;
                                      productsController
                                              .unitSalePriceController.text =
                                          (packSalePrice / unitInPack)
                                              .toString();
                                    }
                                  },
                                ),
                          productsController.isSingleUnit.value
                              ? SizedBox()
                              : TextFieldWithTitle(
                                  title: 'Available Packs',
                                  controller: productsController
                                      .availablePacksController,
                                  onChange: (value) {
                                    if (productsController
                                            .availablePacksController
                                            .text
                                            .isNotEmpty &&
                                        productsController.unitsInPackController
                                            .text.isNotEmpty) {
                                      double unitPerPack = double.tryParse(
                                              productsController
                                                  .unitsInPackController
                                                  .text) ??
                                          0.0;
                                      double availablePacks = double.tryParse(
                                              productsController
                                                  .availablePacksController
                                                  .text) ??
                                          0.0;
                                      productsController
                                              .availableUnitsController.text =
                                          (unitPerPack * availablePacks)
                                              .toString();
                                    }
                                  },
                                ),
                          Obx(
                            () => TextFieldWithTitle(
                              title: 'Available Units',
                              controller:
                                  productsController.availableUnitsController,
                              isReadyOnly:
                                  !productsController.isSingleUnit.value,
                            ),
                          ),
                          Obx(
                            () => productsController.isSingleUnit.value
                                ? SizedBox()
                                : TextFieldWithTitle(
                                    title: 'Pack Purchase Price',
                                    controller: productsController
                                        .packPurchasePriceController,
                                    onChange: (value) {
                                      if (productsController
                                              .packPurchasePriceController
                                              .text
                                              .isNotEmpty &&
                                          productsController
                                              .unitsInPackController
                                              .text
                                              .isNotEmpty) {
                                        double packPurchasePrice =
                                            double.tryParse(productsController
                                                    .packPurchasePriceController
                                                    .text) ??
                                                0.0;
                                        double unitInPack = double.tryParse(
                                                productsController
                                                    .unitsInPackController
                                                    .text) ??
                                            0.0;
                                        productsController
                                                .unitPurchasePriceController
                                                .text =
                                            (packPurchasePrice / unitInPack)
                                                .toString();
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Obx(
                          () => productsController.isSingleUnit.value
                              ? SizedBox()
                              : TextFieldWithTitle(
                                  title: 'Pack Sale Price',
                                  controller: productsController
                                      .packSalePriceController,
                                  onChange: (value) {
                                    if (productsController
                                            .packSalePriceController
                                            .text
                                            .isNotEmpty &&
                                        productsController.unitsInPackController
                                            .text.isNotEmpty) {
                                      double packSalePrice = double.tryParse(
                                              productsController
                                                  .packSalePriceController
                                                  .text) ??
                                          0.0;
                                      double unitInPack = double.tryParse(
                                              productsController
                                                  .unitsInPackController
                                                  .text) ??
                                          0.0;
                                      productsController
                                              .unitSalePriceController.text =
                                          (packSalePrice / unitInPack)
                                              .toString();
                                    }
                                  },
                                ),
                        ),
                        TextFieldWithTitle(
                          title: 'Unit Purchase Price',
                          controller:
                              productsController.unitPurchasePriceController,
                          isReadyOnly: !productsController.isSingleUnit.value,
                        ),
                        TextFieldWithTitle(
                          title: 'Unit Sale Price',
                          controller:
                              productsController.unitSalePriceController,
                          isReadyOnly: !productsController.isSingleUnit.value,
                        ),
                        TextFieldWithTitle(
                          title: 'Barcode',
                          controller: productsController.barcodeController,
                        ),
                        // Expiry Date Picker (no need for Obx as it's a static value)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Expiry Date'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22,
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: TextFormField(
                                controller:
                                    productsController.expiryDateController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: 'Select Expiry Date',
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? value = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (value != null) {
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy').format(value);
                                    productsController.expiryDate =
                                        formattedDate;
                                    productsController.expiryDateController
                                        .text = formattedDate;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  print(productsController.availableUnitsController);
                  productsController.updateProduct(widget.product.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.30, 50),
                  backgroundColor: MyColors.greenColor,
                ),
                child: Text(
                  'Update Product',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
