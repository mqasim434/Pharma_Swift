// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pharmacy_pos/models/order_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class UtilityFunctions {
  static Future<void> printReceipt(
      OrderModel order, BuildContext context) async {
    // Generate PDF document
    final pdf = pw.Document();
    Future<Box<int>> openIdBox() async {
      return await Hive.openBox<int>('lastOrderIdBox');
    }

    final ByteData fontData = await rootBundle
        .load('assets/fonts/Noto Nastaliq Urdu SemiBold - [UrduFonts.com].ttf');
    final font = pw.Font.ttf(fontData);

    final idBox = await openIdBox();
    int lastOrderId = idBox.get('lastOrderId') ?? 0;
    String newOrderId = '$lastOrderId';
    // final ByteData bytes = await rootBundle.load('assets/images/kph.png');
    // final Uint8List imageData = bytes.buffer.asUint8List();

    // Prefetch product details for all order items
    List<Map<String, dynamic>> itemDetails =
        await Future.wait(order.items.map((item) async {
      double total = double.parse(item.salePrice.toString()) * item.quantity;

      return {
        'title': item.name,
        'formula': item.formula,
        'quantity': item.quantity,
        'category': item.category,
        'price': item.salePrice,
        'strength': item.strength,
        'total': total.toStringAsFixed(2),
      };
    }).toList());
    final DateFormat formatter = DateFormat('dd/MM/yyyy h:mm a');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin:
            const pw.EdgeInsets.all(0), // Set margins to 0 to avoid empty space
        build: (pw.Context context) {
          return pw.SizedBox(
              width: 200,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  // pw.Center(
                  //   child: pw.Image(
                  //       pw.MemoryImage(
                  //         imageData,
                  //       ),
                  //       width: 70,
                  //       height: 70),
                  // ),
                  pw.SizedBox(height: 8),
                  pw.Center(
                    child: pw.Text(
                      'AL-NOOR CLINIC',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Center(
                    child: pw.Text(
                      'Ghari Pull, Daulat Nagar. ',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Center(
                    child: pw.Text(
                      'Ph: 0533-572041',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          "_______________",
                        ),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Your Receipt',
                          style: pw.TextStyle(
                            fontSize: 12,
                            height: 0.1,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          "_______________",
                        ),
                      ]),
                  pw.Text(
                    'Bill No: $newOrderId',
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    'Date: ${formatter.format(order.orderDate)}',
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.Divider(),
                  pw.Row(children: [
                    pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          'Name',
                          style: pw.TextStyle(fontSize: 10),
                        )),
                    pw.Expanded(
                        child: pw.Text(
                      'Qty',
                      style: pw.TextStyle(fontSize: 10),
                    )),
                    pw.Expanded(
                        child: pw.Text(
                      'Price',
                      style: pw.TextStyle(fontSize: 10),
                    )),
                    pw.Expanded(
                        child: pw.Text(
                      'Total',
                      style: pw.TextStyle(fontSize: 10),
                    )),
                  ]),
                  pw.SizedBox(height: 4),
                  // Displaying prefetched item details
                  ...itemDetails.map((item) {
                    return pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Row(children: [
                          pw.Text(
                            '${item['title']}(${item['strength']})(${item['category'].toString().substring(0, item['category'].length - 1)})',
                            style: pw.TextStyle(fontSize: 10),
                          )
                        ]),
                        pw.Row(children: [
                          pw.Expanded(flex: 2, child: pw.SizedBox()),
                          pw.Expanded(
                              child: pw.Text(
                            item['quantity'].toString(),
                            style: pw.TextStyle(fontSize: 10),
                          )),
                          pw.Expanded(
                              child: pw.Text(
                            item['price'].toString(),
                            style: pw.TextStyle(fontSize: 10),
                          )),
                          pw.Expanded(
                              child: pw.Text(
                            item['total'].toString(),
                            style: pw.TextStyle(fontSize: 10),
                          )),
                        ]),
                      ],
                    );
                  }),
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total Items: ',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          '${order.items.length}',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total Bill: ',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          '${order.totalAmount.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Discount: ',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          '${order.discount} %',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Net Bill: ',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          '${order.netAmount.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      ]),

                  pw.Divider(),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('Thanks for your order!',
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                          "Returns won't be allowed without receipt.", // Urdu text
                          style: pw.TextStyle(
                            fontSize:
                                10, // Matches the font family in pubspec.yaml
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          "Returns would be allowed withn 10 days.", // Urdu text
                          style: pw.TextStyle(
                            fontSize:
                                10, // Matches the font family in pubspec.yaml
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          "Fridge Items, Cosmetics & Loose packing are not returnable.", // Urdu text
                          style: pw.TextStyle(
                            fontSize:
                                10, // Matches the font family in pubspec.yaml
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ]),
                ],
              ));
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
