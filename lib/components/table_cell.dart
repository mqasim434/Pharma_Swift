import 'package:flutter/material.dart';

Widget tableCell(
  String text, {
  bool isHeader = false,
  bool hasOrderActions = false,
  bool hasOrderViewAction = false,
  bool hasProductActions = false,
  bool isItemsColumn = false,
  void Function()? viewProduct,
  void Function()? editProduct,
  void Function()? deleteProduct,
  void Function()? viewOrder,
  void Function()? deleteOrder,
  void Function()? viewItems,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: isItemsColumn
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: viewItems ?? () {},
                child: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                (text.isEmpty || text == 'null' || text == '') ? 'N/A' : text,
                style: TextStyle(
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                    fontSize: isHeader ? 16 : 14,
                    color: isHeader ? Colors.white : Colors.black),
                textAlign: TextAlign.center,
              )
            ],
          )
        : hasOrderViewAction
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: viewOrder ?? () {},
                    child: const Icon(
                      Icons.remove_red_eye,
                      size: 20,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : hasProductActions
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: viewProduct ?? () {},
                        child: const Icon(
                          Icons.remove_red_eye,
                          size: 20,
                          color: Colors.green,
                        ),
                      ),
                      InkWell(
                        onTap: editProduct ?? () {},
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      InkWell(
                        onTap: deleteProduct ?? () {},
                        child: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
                : hasOrderActions
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: viewOrder ?? () {},
                            child: const Icon(
                              Icons.remove_red_eye,
                              size: 20,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: deleteOrder ?? () {},
                            child: const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          fontWeight:
                              isHeader ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
  );
}
