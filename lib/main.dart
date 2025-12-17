import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚠️ Do NOT await this (prevents app from freezing on splash)
  JustAudioBackground.init(
    androidNotificationChannelId: 'com.music.app.channel.audio',
    androidNotificationChannelName: 'Music Playback',
    androidNotificationOngoing: true,
  );

  runApp(const MyMusicApp());
}

class MyMusicApp extends StatelessWidget {
  const MyMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // 🔥 black theme like Spotify
      home: const MainScreen(), // 🔥 Home / Search / Library
    );
  }
}
