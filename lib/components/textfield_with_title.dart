import 'package:flutter/material.dart';

class TextFieldWithTitle extends StatelessWidget {
  TextFieldWithTitle({
    super.key,
    required this.title,
    required this.controller,
    this.validator,
    this.onChange,
    this.isReadyOnly = false,
  });

  final String title;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChange;
  bool isReadyOnly;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('$title: '),
        SizedBox(
          width: screenWidth * 0.22,
          height: screenHeight * 0.08,
          child: TextFormField(
            style: TextStyle(fontSize: 12),
            readOnly: isReadyOnly,
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Select $title',
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              errorStyle: TextStyle(fontSize: 8),
            ),
            onChanged: onChange ?? (value) {},
            validator: validator ??
                (value) {
                  return null;
                },
          ),
        ),
      ],
    );
  }
}
