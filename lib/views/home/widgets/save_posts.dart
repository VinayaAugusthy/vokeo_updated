import 'package:flutter/material.dart';

class SavePosts extends StatelessWidget {
  const SavePosts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.black,
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (value) {
        if (value == 0) {}
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
