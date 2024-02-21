import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/components/demotivator_content.dart';
import 'package:meme_generator/components/gallery_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';

import 'package:meme_generator/components/image_editor_dialog.dart';
import 'package:meme_generator/components/text_editor_dialog.dart';
import 'package:meme_generator/components/web_modal.dart';

class MemeGeneratorScreen extends StatefulWidget {
  const MemeGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<MemeGeneratorScreen> createState() => _MemeGeneratorScreenState();
}

class _MemeGeneratorScreenState extends State<MemeGeneratorScreen> {
  XFile? image;
  TextEditingController textController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String imageUrl = '';
  double fontSize = 20.0;
  double imageSize = 200.0;
  int item = 0;

  @override
  void dispose() {
    textController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => shareMem(),
        child: const Icon(Icons.share),
      ),
    );
  }

  // Метод для построения AppBar

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Create Demotivator'),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => openModal(0),
          icon: const Icon(Icons.web),
        ),
        IconButton(
          onPressed: () => openModal(1),
          icon: const Icon(Icons.image),
        ),
      ],
    );
  }

  // Метод для построения основного тела экрана, учитывающий условия отображения контента:
  // - Если imageUrl и image равны null, отображается сообщение о отсутствии мема.
  // - Если imageUrl или image не равны null, отображается контент демотиватора.

  Widget buildBody() {
    return imageUrl.isEmpty && image == null
        ? const Center(
            child: Text(
              'нет мема',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          )
        : Center(
            child: DemotivatorContent(
              item: item,
              imageUrl: imageUrl,
              imageSize: imageSize,
              image: image,
              textController: textController,
              fontSize: fontSize,
              onShowEditor: showEditorDialog,
              onImageTap: loadImage,
            ),
          );
  }

  void shareMem() async {
    if (imageUrl.isNotEmpty || image != null) {
      // Создаем временный файл для изображения
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/temp_image.png';

      // Сохраняем изображение во временный файл
      if (image != null) {
        await File(image!.path).copy(imagePath);
      } else if (imageUrl.isNotEmpty) {
        // Если изображение не выбрано, но есть URL, его загружаем
        try {
          final response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            await File(imagePath).writeAsBytes(response.bodyBytes);
          } else {
            print('Ошибка загрузки изображения по URL: ${response.statusCode}');
            return;
          }
        } catch (error) {
          print('Ошибка загрузки изображения по URL: $error');
          return;
        }
      } else {
        print('Изображение не выбрано и URL пуст');
        return;
      }

      String shareText = textController.text;
      // Добавьте ссылку к тексту, если она доступна
      if (imageUrl.isNotEmpty) {
        shareText += '\n\n$imageUrl';
      }

      Share.shareFiles([imagePath], text: shareText, subject: 'Demotivator');
    }
  }

  // Метод для отображения модального диалога в зависимости от индекса:
  // - Если index равен 0, отображается модальное окно для ввода данных из веба.
  // - Если index не равен 0, отображается модальное окно для выбора изображения из галереи.

  void openModal(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return index == 0
            ? WebModal(
                textController: textController,
                imageController: imageController,
                onImageCreate: () => loadImage(item = 1),
              )
            : GalleryModal(
                textController: textController,
                onImageCreate: () => loadImage(item = 0),
              );
      },
    );
  }

  // Метод для отображения редакторского диалога в зависимости от индекса:
  // - Если index равен 0, отображается диалог редактирования текста.
  // - Если index не равен 0, отображается диалог редактирования изображения.

  void showEditorDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return index == 0
            ? TextEditorDialog(
                textController: textController,
                fontSize: fontSize,
                onFontSizeChange: (value) {
                  setState(() {
                    fontSize = value;
                  });
                },
                onDone: () => loadImage(item = 1),
              )
            : ImageEditorDialog(
                textController: textController,
                imageSize: imageSize,
                onImageSizeChange: (value) {
                  setState(() {
                    imageSize = value;
                  });
                },
                onDone: () {
                  if (image == null) {
                    loadImage(item = 0);
                  }
                },
              );
      },
    );
  }

  // Метод для загрузки изображения по индексу:
  // - Если index равен 1, выполняется загрузка изображения по введенной ссылке.
  // - Если index не равен 1, выполняется выбор изображения из галереи.

  void loadImage(int index) async {
    if (index == 1) {
      // Загрузка изображения по ссылке
      final response = await http.get(
        Uri.parse(
          imageController.text,
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          imageUrl = imageController.text;
        });
      } else {
        print('Ошибка загрузки изображения: ${response.statusCode}');
      }
    } else {
      // Выбор изображения из галереи
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          image = pickedImage;
        });
      }
    }
  }
}
