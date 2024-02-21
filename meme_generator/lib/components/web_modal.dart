import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebModal extends StatelessWidget {
  const WebModal({
    Key? key,
    required this.textController,
    required this.imageController,
    required this.onImageCreate,
  }) : super(key: key);

  final TextEditingController textController;
  final TextEditingController imageController;
  final Function() onImageCreate;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                placeholder: 'Введите ссылку',
                controller: imageController,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CupertinoTextField(
                placeholder: 'Введите название',
                controller: textController,
              ),
              ElevatedButton(
                onPressed: () {
                  onImageCreate();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
                child: const Text('Создать'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

