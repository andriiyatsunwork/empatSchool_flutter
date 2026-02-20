/*
 * @author Andrii Yatsun
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';


/**
 * Widget that represents post.
 * Don`t save state of likes.
 * ON PRESS: notify parent onLikePressed.
 */
class InstagramPost extends StatelessWidget {
  final int index;

  const InstagramPost({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppProvider>(context).isDarkMode;

    return Container(
      color: isDarkMode ? Colors.white10 : Colors.grey[200],
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.image, color: Colors.white),
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                // Доступ до моделі через Provider.of
                // listen: false означає, що ми не хочемо перемальовувати сам пост при зміні лайків
                Provider.of<AppProvider>(context, listen: false).addLike();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You liked this post ❤️"),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.favorite, size: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}