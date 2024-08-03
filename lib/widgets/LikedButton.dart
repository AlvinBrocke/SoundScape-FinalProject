import 'package:flutter/material.dart';

class Likedbutton extends StatefulWidget {
  final bool isLiked;
  final void Function()? onTap;
  const Likedbutton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  State<Likedbutton> createState() => _LikedbuttonState();
}

class _LikedbuttonState extends State<Likedbutton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onTap,
      icon: Icon(
        widget.isLiked ? Icons.favorite : Icons.favorite_border,
        color: widget.isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
