import 'package:firebase_sample/controllers/firestore.dart';
import 'package:firebase_sample/controllers/storage.dart';
import 'package:firebase_sample/repository/firebase_provider.dart';
import 'package:firebase_sample/utils.dart';
import 'package:firebase_sample/views/post_page.dart';
import 'package:firebase_sample/views/settings_page.dart';
import 'package:firebase_sample/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const HomePage());
  }

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final postData = ref.watch(postStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
          .pushAndRemoveUntil(SettingsPage.route(), (route) => false);
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: postData.when(
          // データを読み込んでいるとローディングの処理がされる
          loading: () => preloader,
          // エラーが発生するとエラーが表示される
          error: (error, stack) => Text('Error: $error'),
          // Streamで取得したデータが表示される
          data: (postData) {
            return ListView.builder(
                itemCount: postData.length,
                itemBuilder: (context, index) {
                  final post = postData[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 15,
                      child: PostCard(
                          email: post.id,
                          title: post.title,
                          body: post.body,
                          fileType: post.fileType,
                          fileURL: post.fileURL,
                          favorite: post.favorite,
                          editedAt: post.editedAt!,
                          onTap: () {
                            // DataService().editPost(post);
                          },
                          onLongPress: () async {
                            await FirebaseStoreController()
                                .deletePost(post.createdAt!.toIso8601String());
                            if (post.fileType != "") {
                              await CloudStorageController().deleteFile(
                                  post.createdAt!.toIso8601String());
                            }
                          },
                          onFavoriteBtn: () {
                            FirebaseStoreController().favoritePost(post);
                          }),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushAndRemoveUntil(PostPage.route(), (route) => false);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
