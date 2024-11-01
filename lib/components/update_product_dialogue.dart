import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/add_product_dialogue.dart';
import 'package:pharmacy_pos/components/file_upload_widget.dart';
import 'package:pharmacy_pos/database/products_db_helper.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class UpdateProductDialogue extends StatefulWidget {
  final ProductModel product; // Product to be updated

  UpdateProductDialogue({super.key, required this.product});

  bool isSingleUnit = false;

  @override
  State<UpdateProductDialogue> createState() => _UpdateProductDialogueState();
}

class _UpdateProductDialogueState extends State<UpdateProductDialogue> {
  late TextEditingController titleController;
  late TextEditingController formulaController;
  late TextEditingController strengthController;
  late TextEditingController barcodeController;
  late TextEditingController unitPriceController;
  late TextEditingController blisterPriceController;
  late TextEditingController packPriceController;
  late TextEditingController unitsController;
  late TextEditingController expiryDateController;
  late TextEditingController batchNoController;
  late TextEditingController rackNoController;
  late TextEditingController unitsPerPack;
  late TextEditingController vendorController;
  late TextEditingController unitsPerBlisterController;

  String? selectedCategory;
  DateTime? expiryDate;
  String? selectedImage;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing product data
    titleController = TextEditingController(text: widget.product.name);
    formulaController = TextEditingController(text: widget.product.formula);
    strengthController =
        TextEditingController(text: widget.product.strength.toString());
    barcodeController = TextEditingController(text: widget.product.barcode);
    unitPriceController =
        TextEditingController(text: widget.product.unitPrice.toString());
    blisterPriceController =
        TextEditingController(text: widget.product.blistersPerPack.toString());
    packPriceController =
        TextEditingController(text: widget.product.pricePerPack.toString());
    unitsController =
        TextEditingController(text: widget.product.availableUnits.toString());
    expiryDateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(widget.product.expiryDate));
    batchNoController = TextEditingController(text: widget.product.batchNumber);
    rackNoController = TextEditingController(text: widget.product.rackNo);
    unitsPerPack =
        TextEditingController(text: widget.product.quantity.toString());
    vendorController = TextEditingController(text: widget.product.vendor);
    unitsPerBlisterController =
        TextEditingController(text: widget.product.unitsPerBlister.toString());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 50),
          const Text("Update Product", style: TextStyle(fontWeight: FontWeight.w500)),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close),
          ),
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
                      children: [
                        TextFieldWithTitle(
                            title: 'Product Title',
                            controller: titleController),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Is Single Unit'),
                              Container(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.06,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Is Single Unit?',
                                        style: TextStyle(fontSize: 16)),
                                    Checkbox(
                                      value: widget.isSingleUnit,
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          setState(() {
                                            widget.isSingleUnit = value;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.isSingleUnit
                            ? const SizedBox()
                            : TextFieldWithTitle(
                                title: 'Formula',
                                controller: formulaController),
                        widget.isSingleUnit
                            ? const SizedBox()
                            : TextFieldWithTitle(
                                title: 'Strength',
                                controller: strengthController),
                        TextFieldWithTitle(
                            title: 'Barcode', controller: barcodeController),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Category:'),
                              SizedBox(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.06,
                                child: DropdownButtonFormField<String>(
                                  value:
                                      selectedCategory ?? widget.product.type,
                                  hint: const Text('Select Category'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  items: [
                                    'Pills',
                                    'Syrups',
                                    'Capsules',
                                    'Injections'
                                  ]
                                      .map((String category) =>
                                          DropdownMenuItem(
                                              value: category,
                                              child: Text(category)))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
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
                              const Text('Expiry Date'),
                              SizedBox(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.06,
                                child: TextFormField(
                                  controller: expiryDateController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                    hintText: 'Select Expiry Date',
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    var value = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );
                                    if (value != null) {
                                      expiryDate = value;
                                      expiryDateController.text =
                                          DateFormat('dd/MM/yyyy')
                                              .format(value);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
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
                            controller: unitsController),
                        TextFieldWithTitle(
                            title: 'Units per Pack', controller: unitsPerPack),
                        TextFieldWithTitle(
                            title: 'Unit Price',
                            controller: unitPriceController),
                        TextFieldWithTitle(
                            title: 'Blister Price',
                            controller: blisterPriceController),
                        TextFieldWithTitle(
                            title: 'Pack Price',
                            controller: packPriceController),
                        TextFieldWithTitle(
                            title: 'Rack No', controller: rackNoController),
                        TextFieldWithTitle(
                            title: 'Batch No', controller: batchNoController),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ProductModel updatedProduct = ProductModel(
                    name: titleController.text,
                    type: selectedCategory ?? widget.product.type,
                    formula: formulaController.text,
                    vendor: vendorController.text,
                    expiryDate: expiryDate ?? widget.product.expiryDate,
                    batchNumber: batchNoController.text,
                    rackNo: rackNoController.text,
                    unitPrice: double.parse(unitPriceController.text),
                    barcode: barcodeController.text,
                    blistersPerPack: int.parse(blisterPriceController.text),
                    availableUnits: int.parse(unitsPerPack.text),
                    unitsPerBlister: widget.product.unitsPerBlister,
                    imageUrl: selectedImage ?? widget.product.imageUrl,
                  );

                  // Call the update method from the database helper
                  ProductsDBController productsController =
                      Get.find<ProductsDBController>();
                  productsController
                      .updateProductByName(widget.product.name, updatedProduct)
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.65, 50),
                  backgroundColor: MyColors.greenColor,
                ),
                child: const Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
