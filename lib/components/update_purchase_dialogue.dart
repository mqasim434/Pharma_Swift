import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/components/textfield_with_title.dart';
import 'package:pharmacy_pos/controllers/filter_controller.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/controllers/purchase_controller.dart';
import 'package:pharmacy_pos/models/purchase_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class UpdatePurchaseDialogue extends StatefulWidget {
  const UpdatePurchaseDialogue({super.key, required this.purchaseModel});

  final PurchaseModel purchaseModel;

  @override
  State<UpdatePurchaseDialogue> createState() => _UpdatePurchaseDialogueState();
}

class _UpdatePurchaseDialogueState extends State<UpdatePurchaseDialogue> {
  var productsController = Get.put<ProductsController>(ProductsController());
  var purchaseController = Get.put<PurchaseController>(PurchaseController());
  var filtersController = Get.put<FiltersController>(FiltersController());
  @override
  void initState() {
    // TODO: implement initState
    purchaseController.nameController.text =
        widget.purchaseModel.productTitle.toString();
    purchaseController.isSingleUnit.value = widget.purchaseModel.isSingleUnit;
    purchaseController.categoryController.text =
        widget.purchaseModel.category.toString();
    purchaseController.companyController.text =
        widget.purchaseModel.company.toString();
    purchaseController.formulaController.text =
        widget.purchaseModel.formula.toString();
    purchaseController.strengthController.text =
        widget.purchaseModel.strength.toString();
    purchaseController.batchNumberController.text =
        widget.purchaseModel.batchNumber.toString();
    purchaseController.unitsInPackController.text =
        widget.purchaseModel.unitsInPack.toString();
    purchaseController.availablePacksController.text =
        widget.purchaseModel.availablePacks.toString();
    purchaseController.availableUnitsController.text =
        widget.purchaseModel.availableUnits.toString();
    purchaseController.packPurchasePriceController.text =
        widget.purchaseModel.packPurchasePrice.toString();
    purchaseController.unitPurchasePriceController.text =
        widget.purchaseModel.unitPurchasePrice.toString();
    purchaseController.expiryDateController.text =
        widget.purchaseModel.expiryDate.toString();
    purchaseController.purchaseDateController.text =
        widget.purchaseModel.purchaseDate.toString();
    super.initState();
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
            "Update Purchase",
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
          child: Form(
            key: productsController.formKey,
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
                            controller: purchaseController.nameController,
                            onChange: (value) {
                              filtersController.searchProducts(
                                  value, productsController.productList);
                            },
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
                                          value: purchaseController
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
                            title: 'Category',
                            controller: purchaseController.categoryController,
                          ),
                          TextFieldWithTitle(
                            title: 'Formula',
                            controller: purchaseController.formulaController,
                          ),
                          TextFieldWithTitle(
                            title: 'Strength',
                            controller: purchaseController.strengthController,
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
                                  purchaseController.batchNumberController,
                            ),
                            TextFieldWithTitle(
                              title: 'Company',
                              controller: purchaseController.companyController,
                            ),
                            purchaseController.isSingleUnit.value
                                ? const SizedBox()
                                : TextFieldWithTitle(
                                    title: 'Units per Pack',
                                    controller: purchaseController
                                        .unitsInPackController,
                                    onChange: (value) {
                                      if (purchaseController
                                              .availablePacksController
                                              .text
                                              .isNotEmpty &&
                                          purchaseController
                                              .unitsInPackController
                                              .text
                                              .isNotEmpty) {
                                        double unitPerPack = double.tryParse(
                                                purchaseController
                                                    .unitsInPackController
                                                    .text) ??
                                            0.0;
                                        double availablePacks = double.tryParse(
                                                purchaseController
                                                    .availablePacksController
                                                    .text) ??
                                            0.0;
                                        purchaseController
                                                .availableUnitsController.text =
                                            (unitPerPack * availablePacks)
                                                .toString();
                                      }
                                      if (purchaseController
                                              .packPurchasePriceController
                                              .text
                                              .isNotEmpty &&
                                          purchaseController
                                              .unitsInPackController
                                              .text
                                              .isNotEmpty) {
                                        double packPurchasePrice =
                                            double.tryParse(purchaseController
                                                    .packPurchasePriceController
                                                    .text) ??
                                                0.0;
                                        double unitInPack = double.tryParse(
                                                purchaseController
                                                    .unitsInPackController
                                                    .text) ??
                                            0.0;
                                        purchaseController
                                                .unitPurchasePriceController
                                                .text =
                                            (packPurchasePrice / unitInPack)
                                                .toString();
                                      }
                                    },
                                  ),
                            purchaseController.isSingleUnit.value
                                ? const SizedBox()
                                : TextFieldWithTitle(
                                    title: 'Available Packs',
                                    controller: purchaseController
                                        .availablePacksController,
                                    onChange: (value) {
                                      if (purchaseController
                                              .availablePacksController
                                              .text
                                              .isNotEmpty &&
                                          purchaseController
                                              .unitsInPackController
                                              .text
                                              .isNotEmpty) {
                                        double unitPerPack = double.tryParse(
                                                purchaseController
                                                    .unitsInPackController
                                                    .text) ??
                                            0.0;
                                        double availablePacks = double.tryParse(
                                                purchaseController
                                                    .availablePacksController
                                                    .text) ??
                                            0.0;
                                        purchaseController
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
                                    purchaseController.availableUnitsController,
                                isReadyOnly:
                                    !purchaseController.isSingleUnit.value,
                              ),
                            ),
                            Obx(
                              () => purchaseController.isSingleUnit.value
                                  ? const SizedBox()
                                  : TextFieldWithTitle(
                                      title: 'Pack Purchase Price',
                                      controller: purchaseController
                                          .packPurchasePriceController,
                                      onChange: (value) {
                                        if (purchaseController
                                                .packPurchasePriceController
                                                .text
                                                .isNotEmpty &&
                                            purchaseController
                                                .unitsInPackController
                                                .text
                                                .isNotEmpty) {
                                          double packPurchasePrice =
                                              double.tryParse(purchaseController
                                                      .packPurchasePriceController
                                                      .text) ??
                                                  0.0;
                                          double unitInPack = double.tryParse(
                                                  purchaseController
                                                      .unitsInPackController
                                                      .text) ??
                                              0.0;
                                          purchaseController
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
                            () => TextFieldWithTitle(
                              title: 'Unit Purchase Price',
                              controller: purchaseController
                                  .unitPurchasePriceController,
                              isReadyOnly:
                                  !purchaseController.isSingleUnit.value,
                            ),
                          ),

                          // Expiry Date Picker (no need for Obx as it's a static value)
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
                                      purchaseController.expiryDateController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
                                          DateFormat('dd/MM/yyyy')
                                              .format(value);
                                      purchaseController.expiryDate.value =
                                          formattedDate;
                                      purchaseController.expiryDateController
                                          .text = formattedDate;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Purchase Date Date'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.22,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: TextFormField(
                                  controller:
                                      purchaseController.purchaseDateController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    hintText: 'Select Purchase Date',
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
                                          DateFormat('dd/MM/yyyy')
                                              .format(value);
                                      purchaseController.purchaseDateController
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
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    print(purchaseController.availableUnitsController);
                    purchaseController
                        .updatePurchase(widget.purchaseModel.purchaseId);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.30, 50),
                    backgroundColor: MyColors.greenColor,
                  ),
                  child: const Text(
                    'Update Purchase',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
