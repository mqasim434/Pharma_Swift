// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/blister-pack.png',
              width: 100,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Product Title',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Formula',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Unit Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  
  }
}
