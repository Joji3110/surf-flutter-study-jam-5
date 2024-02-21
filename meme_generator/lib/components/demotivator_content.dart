import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DemotivatorContent extends StatelessWidget {
  const DemotivatorContent({
    Key? key,
    required this.item,
    required this.imageUrl,
    required this.imageSize,
    required this.image,
    required this.textController,
    required this.fontSize,
    required this.onShowEditor,
    required this.onImageTap,
  }) : super(key: key);

  final int item;
  final String imageUrl;
  final double imageSize;
  final XFile? image;
  final TextEditingController textController;
  final double fontSize;
  final Function(int) onShowEditor;
  final Function(int) onImageTap;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
    );

    return ColoredBox(
      color: Colors.black,
      child: DecoratedBox(
        decoration: decoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: decoration,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: item == 1
                        ? imageUrl.isEmpty
                            ? const Center(
                                child: CupertinoActivityIndicator(
                                    color: Colors.white),
                              )
                            : GestureDetector(
                                onTap: () => onShowEditor(1),
                                child: Image.network(
                                  imageUrl,
                                  width: imageSize,
                                  height: imageSize,
                                  fit: BoxFit.contain,
                                ),
                              )
                        : image != null
                            ? GestureDetector(
                                onTap: () => onShowEditor(2),
                                child: Image.file(
                                  File(image!.path),
                                  width: imageSize,
                                  height: imageSize,
                                ),
                              )
                            : const Text('Изображение не выбрано'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onShowEditor(0),
                child: Text(
                  textController.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Impact',
                    fontSize: fontSize,
                    color: Colors.white,
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