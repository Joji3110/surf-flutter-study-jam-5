
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryModal extends StatelessWidget {
  const GalleryModal({
    Key? key,
    required this.textController,
    required this.onImageCreate,
  }) : super(key: key);

  final TextEditingController textController;
  final Function() onImageCreate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Загрузить из галереи'),
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
              onPressed: () => onImageCreate(),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          CupertinoTextField(
            placeholder: 'Введите название',
            controller: textController,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          child: const Text('Создать'),
        )
      ],
    );
  }
}

