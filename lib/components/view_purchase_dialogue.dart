import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/components/textfield_with_title.dart';
import 'package:pharmacy_pos/models/purchase_model.dart';

class ViewPurchaseDialogue extends StatelessWidget {
  const ViewPurchaseDialogue({super.key,required this.purchaseModel});

  final PurchaseModel purchaseModel;

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
            "View Purchase",
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
                          hint: purchaseModel.productTitle,
                          isReadyOnly: true,
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
                                    Checkbox(
                                        value: purchaseModel.isSingleUnit,
                                        onChanged: (bool? value) {},
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        TextFieldWithTitle(
                          title: 'Category',
                          hint: purchaseModel.category,
                          isReadyOnly: true,
                        ),
                        TextFieldWithTitle(
                          title: 'Formula',
                          hint: 'Formula',
                          isReadyOnly: true,
                        ),
                        TextFieldWithTitle(
                          title: 'Strength',
                          hint: 'strength',
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
                            hint: purchaseModel.batchNumber,
                            isReadyOnly: true,
                          ),
                          TextFieldWithTitle(
                            title: 'Company',
                            hint: purchaseModel.company,
                            isReadyOnly: true,
                          ),
                          purchaseModel.isSingleUnit
                              ? const SizedBox()
                              : TextFieldWithTitle(
                                  title: 'Units per Pack',
                                  hint: purchaseModel.unitsInPack.toString(),
                                  isReadyOnly: true,
                                ),
                          purchaseModel.isSingleUnit
                              ? const SizedBox()
                              : TextFieldWithTitle(
                                  title: 'Available Packs',
                                  hint: purchaseModel.availablePacks.toString(),
                                  isReadyOnly: true,
                                ),
                         TextFieldWithTitle(
                              title: 'Available Units',
                               hint: purchaseModel.availableUnits.toString(),
                              isReadyOnly: true,
                            ),
                          purchaseModel.isSingleUnit
                                ? const SizedBox()
                                : TextFieldWithTitle(
                                    title: 'Pack Purchase Price',
                                     hint: purchaseModel.packPurchasePrice.toString(),
                                    isReadyOnly: true,
                                  ),
                        ],
                      ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFieldWithTitle(
                            title: 'Unit Purchase Price',
                             hint: purchaseModel.unitPurchasePrice.toString(),
                            isReadyOnly: true,
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
                                
                                decoration: InputDecoration(
                                  
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                   hintText: purchaseModel.expiryDate.toString(),
                                ),
                                readOnly: true,
                                onTap: () async {},
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
                                
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                   hintText: purchaseModel.purchaseDate.toString(),
                                ),
                                readOnly: true,
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
            ],
          ),
        ),
      ),
    );
  }
}
