import 'dart:io';

import 'package:firebase_sample/repository/firebase_provider.dart';
import 'package:firebase_sample/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// TextFieldの値を保存するプロバイダー
// 使い終わったら、状態を破棄するautoDisposeを追加しておく
final titleProvider =
    StateProvider.autoDispose((ref) => TextEditingController(text: ''));
final bodyProvider =
    StateProvider.autoDispose((ref) => TextEditingController(text: ''));

/// 画像表示用Provider
final fileStateProvider = StateProvider<File?>((ref) => null);

/// fileStateProviderが画像か動画か判定
final fileTypeProvider = StateProvider<bool>((ref) => true);

class PostPage extends ConsumerWidget {
  File? file;
  final picker = ImagePicker();

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => PostPage());
  }

  PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingControllerを使えるように呼び出す
    final title = ref.watch(titleProvider);
    final body = ref.watch(bodyProvider);
    // データを保存するメソッドを呼び出す
    final firebaseStoreService = ref.read(firebaseStoreProvider.notifier).state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
        actions: [
          ElevatedButton.icon(
              onPressed: () async {
                // データを保存するメソッドを使用する。ボタンを押すと実行される
                await firebaseStoreService.addPost(title.text, body.text, file,
                    ref.read(fileTypeProvider.notifier).state);

                file = null;
                ref.read(fileStateProvider.notifier).state = await null;
              },
              icon: const Icon(Icons.post_add),
              label: const Text("投稿"))
        ],
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
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
          OutlinedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('画像を選択'),
                        onTap: () async {
                          /// 画像
                          final pickedFileImage = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFileImage != null) {
                            file = File(pickedFileImage.path);
                            ref.read(fileStateProvider.notifier).state = file;
                            ref.read(fileTypeProvider.notifier).state = true;
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('ビデオを選択'),
                        onTap: () async {
                          /// 動画
                          final pickedFileVideo = await picker.pickVideo(
                              source: ImageSource.gallery);
                          if (pickedFileVideo != null) {
                            file = File(pickedFileVideo.path);
                            ref.read(fileStateProvider.notifier).state = file;
                            ref.read(fileTypeProvider.notifier).state = false;
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("ファイルを追加"),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
              child: ref.watch(fileStateProvider) != null
                  ? ref.watch(fileTypeProvider)
                      ? Image.file(
                          ref.watch(fileStateProvider)!,
                          fit: BoxFit.cover,
                        )
                      : VideoPlayerItem(
                          videoUrl: ref.watch(fileStateProvider)!.path)
                  : const SizedBox()),
        ],
      )),
    );
  }
}
