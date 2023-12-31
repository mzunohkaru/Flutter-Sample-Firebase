import 'dart:io';

import 'package:firebase_sample/firebases/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// TextFieldの値を保存するプロバイダー
// 使い終わったら、状態を破棄するautoDisposeを追加しておく
final titleProvider =
    StateProvider.autoDispose((ref) => TextEditingController(text: ''));
final bodyProvider =
    StateProvider.autoDispose((ref) => TextEditingController(text: ''));

class PostPage extends ConsumerWidget {
  File? file;

  PostPage({super.key});

  /// 画像を選択
  Future pickupImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingControllerを使えるように呼び出す
    final title = ref.watch(titleProvider);
    final body = ref.watch(bodyProvider);
    // データを保存するメソッドを呼び出す
    final dataService = ref.read(dataServiceProvider.notifier).state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
        actions: [
          ElevatedButton.icon(
              onPressed: () async {
                // データを保存するメソッドを使用する。ボタンを押すと実行される
                await dataService.addPost(title.text, body.text, file);
              },
              icon: const Icon(Icons.post_add),
              label: const Text("投稿"))
        ],
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("タイトル"),
            ),
            controller: title,
          ),
          const SizedBox(height: 10.0),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("内容"),
            ),
            controller: body,
          ),
          const SizedBox(height: 30.0),
          InkWell(
            onTap: pickupImage,
            child: file == null
                ? Container(
                    margin: const EdgeInsets.all(10),
                    height: 80,
                    width: 55,
                    child: const Icon(Icons.image),
                  )
                : Image.file(file!),
          ),
        ],
      )),
    );
  }
}
