import 'package:firebase_sample/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String email;
  final String title;
  final String body;
  final String fileType;
  final String fileURL;
  final int favorite;
  final DateTime editedAt;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavoriteBtn;

  const PostCard(
      {super.key,
      required this.email,
      required this.title,
      required this.body,
      required this.fileType,
      required this.fileURL,
      required this.favorite,
      required this.editedAt,
      required this.onTap,
      required this.onLongPress,
      required this.onFavoriteBtn});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black
                      // image: DecorationImage(
                      // image: AssetImage(post.userImage),
                      // fit: BoxFit.cover),
                      ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      email,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      editedAt.toIso8601String(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert)
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            const SizedBox(height: 5),
            Align(alignment: Alignment.topLeft, child: Text(body)),
            const SizedBox(height: 5),
            if (fileType == "image") Image.network(fileURL),
            if (fileType == "video")
              VideoPlayerItem(
                videoUrl: fileURL,
              ),
            Row(
              children: [
                IconButton(
                    onPressed: onFavoriteBtn,
                    icon: Icon(Icons.favorite_border)),
                const SizedBox(width: 2),
                Text(favorite.toString()),
                const SizedBox(width: 10),
                IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
                const SizedBox(width: 2),
                Text('9XX'),
                const Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.share_sharp)),
                const SizedBox(width: 5),
                IconButton(onPressed: () {}, icon: Icon(Icons.bookmark)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
