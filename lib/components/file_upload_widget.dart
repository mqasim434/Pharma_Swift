import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUploadWidget extends StatefulWidget {
  final Function(List<File>) onFilesSelected; // Callback function

  FileUploadWidget({required this.onFilesSelected}); // Require the callback

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  bool isDragging = false;
  List<File> files = [];

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result != null) {
      List<File> pickedFiles = result.paths.map((path) => File(path!)).toList();
      setState(() {
        files = pickedFiles;
      });
      widget.onFilesSelected(files); // Pass files to callback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropTarget(
        onDragEntered: (details) {
          setState(() {
            isDragging = true;
          });
        },
        onDragExited: (details) {
          setState(() {
            isDragging = false;
          });
        },
        onDragDone: (details) {
          setState(() {
            files.addAll(details.files.map((x) => File(x.path)));
          });
          widget.onFilesSelected(files); // Pass files to callback
        },
        child: GestureDetector(
          onTap: pickFiles,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Image'),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDragging ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: files.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_upload, size: 50),
                            Text(
                              isDragging
                                  ? 'Drop files here'
                                  : 'Drag or Click to Upload',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Image.file(files.first),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_upload, size: 50),
                                  Text(
                                    isDragging
                                        ? 'Drop file here'
                                        : 'Drag or Click to Update',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
