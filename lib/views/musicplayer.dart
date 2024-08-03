import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/beat_model.dart';

class MusicPlayer extends StatefulWidget {
  final Beat beat;

  const MusicPlayer({
    super.key,
    required this.beat,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isPlaying = false;
    audioPlayer = AudioPlayer();
  }

  Future<void> playMusic() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(
        widget.beat.audioUrl,
      ));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom app bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {/* Implement menu functionality */},
                      ),
                    ],
                  ),
                ],
              ),
              // Cover Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: widget.beat.imageUrl.isEmpty
                      ? Container(
                          height: 120,
                          color: Colors.grey,
                          width: double.infinity,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 50,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.beat.imageUrl,
                          placeholder: (context, url) => const Icon(
                            Icons.camera_alt,
                            size: 60,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.camera_alt,
                            size: 60,
                          ),
                        ),
                  // child: Image.asset(
                  //   beat.imageUrl,
                  //   height: 300,
                  //   width: 300,
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              const SizedBox(height: 20),
              // Beat Title, Artist, and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.beat.title,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.beat.artist,
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.white),
                        onPressed: () {/* Implement favorite functionality */},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Progress Bar
              Slider(
                value: 0,
                min: 0,
                max: 100,
                onChanged: (value) {/* Implement seek functionality */},
                activeColor: Colors.white,
                inactiveColor: Colors.grey[800],
              ),
              // Time indicators
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0:00', style: TextStyle(color: Colors.grey)),
                    Text('-3:29', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Music Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shuffle, color: Colors.white),
                    onPressed: () {/* Implement shuffle functionality */},
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 36),
                    onPressed: () {/* Implement previous functionality */},
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause_circle_filled,
                        color: Colors.white, size: 64),
                    onPressed: () async {
                      /* Implement play/pause functionality */
                      await playMusic();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 36),
                    onPressed: () {/* Implement next functionality */},
                  ),
                  IconButton(
                    icon: const Icon(Icons.repeat, color: Colors.white),
                    onPressed: () {/* Implement repeat functionality */},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
