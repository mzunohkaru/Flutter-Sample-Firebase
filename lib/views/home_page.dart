import 'package:firebase_sample/firebases/firestore.dart';
import 'package:firebase_sample/repository/post_provider.dart';
import 'package:firebase_sample/views/post_page.dart';
import 'package:firebase_sample/views/settings_page.dart';
import 'package:firebase_sample/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: postData.when(
          // データを読み込んでいるとローディングの処理がされる
          loading: () => const Center(child: CircularProgressIndicator()),
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
                          fileURL: post.fileURL,
                          favorite: post.favorite,
                          editedAt: post.editedAt!,
                          onTap: () {
                            // DataService().editPost(post);
                          },
                          onLongPress: () {
                            DataService()
                                .deletePost(post.createdAt!.toIso8601String());
                          },
                          onFavoriteBtn: () {
                            DataService().favoritePost(post);
                          }),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ref.read(counterProvider.notifier).increment();
          // addData(ref);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PostPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
