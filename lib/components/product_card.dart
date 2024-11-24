// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/components/update_product_dialogue.dart';
import 'package:pharmacy_pos/controllers/products_controller.dart';
import 'package:pharmacy_pos/database/products_db_helper.dart';
import 'package:pharmacy_pos/models/product_model.dart';
import 'package:pharmacy_pos/utils/colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {super.key, required this.productModel, this.showActions = false});
  final ProductModel productModel;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    Get.put<ProductsController>(ProductsController());
    var productsController = Get.find<ProductsController>();
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${productModel.name}${productModel.category}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    productModel.formula ?? 'N/A',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    productModel.unitPurchasePrice.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        showActions
            ? Positioned(
                right: 20,
                top: 20,
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Select an option'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return UpdateProductDialogue(
                                              product: productModel);
                                        });
                                  },
                                  child: ListTile(
                                    title: Text("Edit Product"),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Are you sure to delete (${productModel.name})?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  productsController
                                                      .deleteProduct(
                                                          productModel.id
                                                              .toString());
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Yes'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: ListTile(
                                    title: Text("Delete Product"),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    backgroundColor: MyColors.greenColor,
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
