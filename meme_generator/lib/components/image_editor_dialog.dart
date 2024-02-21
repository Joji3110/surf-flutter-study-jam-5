
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageEditorDialog extends StatelessWidget {
  const ImageEditorDialog({
    Key? key,
    required this.textController,
    required this.imageSize,
    required this.onImageSizeChange,
    required this.onDone,
  }) : super(key: key);

  final TextEditingController textController;
  final double imageSize;
  final Function(double) onImageSizeChange;
  final Function() onDone;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.image,
              ),
              onPressed: () => onDone(),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          CupertinoTextField(
            placeholder: 'Введите название',
            controller: textController,
          ),
          Row(
            children: [
              const Text('Размер изображения:'),
              const SizedBox(width: 10.0),
              Text(imageSize.toStringAsFixed(2)),
            ],
          ),
          Slider(
            value: imageSize,
            min: 50.0,
            max: 400.0,
            onChanged: (value) {
              onImageSizeChange(value);
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            onDone();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          child: const Text('Готово'),
        ),
      ],
    );
  }
}
