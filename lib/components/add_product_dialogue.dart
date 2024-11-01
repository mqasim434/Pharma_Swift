// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/file_upload_widget.dart';
import 'package:pharmacy_pos/database/products_db_helper.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class AddProductDialogue extends StatefulWidget {
  AddProductDialogue({super.key});

  bool isSingleUnit = false;

  @override
  State<AddProductDialogue> createState() => _AddProductDialogueState();
}

class _AddProductDialogueState extends State<AddProductDialogue> {
  @override
  Widget build(BuildContext context) {
    // Controllers
    final TextEditingController titleController = TextEditingController();
    final TextEditingController formulaController = TextEditingController();
    final TextEditingController strengthController = TextEditingController();
    final TextEditingController barcodeController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();
    final TextEditingController blisterPriceController =
        TextEditingController();
    final TextEditingController packPriceController = TextEditingController();
    final TextEditingController unitsController = TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();
    final TextEditingController bactchNoController = TextEditingController();
    final TextEditingController rackNoController = TextEditingController();
    final TextEditingController unitsPerPack = TextEditingController();
    final TextEditingController vendorController = TextEditingController();
    final TextEditingController unitsPerBlisterController =
        TextEditingController();

    // Category selection
    String? selectedCategory;
    DateTime? expiryDate;

    Get.put<ProductsDBController>(ProductsDBController());
    var productsController = Get.find<ProductsDBController>();

    final List<String> categories = [
      'Pills',
      'Syrups',
      'Capsules',
      'Injections'
    ];

    String? selectedImage;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            "Add Product",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close),
          )
        ],
      ),
      content: SizedBox(
        width: screenWidth * 0.7,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          controller: titleController,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Is Single Unit'),
                              Container(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.06,
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
                                    Checkbox(
                                      value: widget.isSingleUnit,
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          setState(() {
                                            widget.isSingleUnit = value;
                                          });
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        widget.isSingleUnit
                            ? SizedBox()
                            : TextFieldWithTitle(
                                title: 'Formula',
                                controller: formulaController,
                              ),
                        widget.isSingleUnit
                            ? SizedBox()
                            : TextFieldWithTitle(
                                title: 'Strength',
                                controller: strengthController,
                              ),
                        TextFieldWithTitle(
                          title: 'Barcode',
                          controller: barcodeController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select Category:'),
                              SizedBox(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.06,
                                child: DropdownButtonFormField<String>(
                                  value: selectedCategory,
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
                                    selectedCategory = value.toString();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Expiry Date'),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.22,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: TextFormField(
                                      controller: expiryDateController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        hintText: 'Select Expiry Date',
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        var value = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2030),
                                        );
                                        expiryDate = value;
                                        expiryDateController.text =
                                            DateFormat('dd/mm/yy')
                                                .format(value as DateTime)
                                                .toString();
                                      },
                                    )),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldWithTitle(
                          title: 'Available Unit',
                          controller: unitsController,
                        ),
                        TextFieldWithTitle(
                          title: 'Units per Pack',
                          controller: unitsPerPack,
                        ),
                        TextFieldWithTitle(
                          title: 'Unit Price',
                          controller: unitPriceController,
                        ),
                        TextFieldWithTitle(
                          title: 'Blister Price',
                          controller: blisterPriceController,
                        ),
                        TextFieldWithTitle(
                          title: 'Pack Price',
                          controller: packPriceController,
                        ),
                        TextFieldWithTitle(
                          title: 'Rack No',
                          controller: rackNoController,
                        ),
                        TextFieldWithTitle(
                          title: 'Batch No',
                          controller: bactchNoController,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      TextFieldWithTitle(
                          title: 'Vendor', controller: vendorController),
                      SizedBox(
                          height: 150,
                          width: screenWidth * 0.22,
                          child: FileUploadWidget(
                            onFilesSelected: (value) {
                              setState(() {
                                selectedImage = value.first.path;
                              });
                            },
                          ))
                    ],
                  )),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  ProductModel productModel = ProductModel(
                      name: titleController.text,
                      type: selectedCategory.toString(),
                      formula: formulaController.text,
                      vendor: vendorController.text,
                      expiryDate: expiryDate as DateTime,
                      batchNumber: bactchNoController.text,
                      rackNo: rackNoController.text,
                      unitPrice: double.parse(unitPriceController.text),
                      barcode: barcodeController.text,
                      blistersPerPack: int.parse(blisterPriceController.text),
                      availableUnits: int.parse(unitsPerPack.text),
                      unitsPerBlister: 0,
                      imageUrl: selectedImage);
                  productsController.addProduct(productModel).then((value) {
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.4, 50),
                  backgroundColor: MyColors.greenColor,
                ),
                child: Text(
                  'Add Product',
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

class TextFieldWithTitle extends StatelessWidget {
  const TextFieldWithTitle({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('$title: '),
          SizedBox(
            width: screenWidth * 0.22,
            height: screenHeight * 0.06,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Select $title',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
