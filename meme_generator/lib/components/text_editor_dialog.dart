import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextEditorDialog extends StatelessWidget {
  const TextEditorDialog({
    Key? key,
    required this.textController,
    required this.fontSize,
    required this.onFontSizeChange,
    required this.onDone,
  }) : super(key: key);

  final TextEditingController textController;
  final double fontSize;
  final Function(double) onFontSizeChange;
  final Function() onDone;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoTextField(
            placeholder: 'Изменить название',
            controller: textController,
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Text('Размер шрифта:'),
              const SizedBox(width: 10.0),
              Text(fontSize.toStringAsFixed(2)),
            ],
          ),
          Slider(
            value: fontSize,
            max: 60.0,
            min: 10.0,
            onChanged: (value) {
              onFontSizeChange(value);
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
          child: const Text('Готово'),
        ),
      ],
    );
  }
}