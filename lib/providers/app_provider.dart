import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../theme/theme.dart';

class AppProvider with ChangeNotifier, WidgetsBindingObserver {
  ThemeData _themeData = darkMode;
  ThemeData get themeData => _themeData;

  bool isSoundOn = true;
  bool isMusicOn = true;

  final _audioPlayer = AudioPlayer();
  bool _isMusicPlaying = false;

  AppProvider() {
    WidgetsBinding.instance.addObserver(this);
    _playBackgroundMusic();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        if (isMusicOn) {
          _playBackgroundMusic();
        }
      case AppLifecycleState.inactive:
        _pauseBackgroundMusic();
      case AppLifecycleState.paused:
        _pauseBackgroundMusic();
      case AppLifecycleState.detached:
        _stopBackgroundMusic();
      case AppLifecycleState.hidden:
        _pauseBackgroundMusic();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopBackgroundMusic();
    super.dispose();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    themeData = (_themeData == lightMode) ? darkMode : lightMode;
  }

  void toggleSound() {
    isSoundOn = !isSoundOn;
    notifyListeners();
  }

  void toggleMusic() {
    isMusicOn = !isMusicOn;
    if (isMusicOn) {
      _playBackgroundMusic();
    } else {
      _stopBackgroundMusic();
    }
    notifyListeners();
  }

  void _playBackgroundMusic() async {
    try {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(
        volume: 0.7,
        AssetSource('audio/bg_music.mp3'),
      );
      _isMusicPlaying = true;
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  void _pauseBackgroundMusic() {
    if (_isMusicPlaying) {
      _audioPlayer.pause();
      _isMusicPlaying = false;
    }
  }

  void _stopBackgroundMusic() {
    if (_isMusicPlaying) {
      _audioPlayer.stop();
      _isMusicPlaying = false;
    }
  }
}
