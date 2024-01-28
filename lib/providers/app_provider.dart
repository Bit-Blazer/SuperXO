import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AppProvider with ChangeNotifier {
  ThemeData _themeData = darkMode;
  ThemeData get themeData => _themeData;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    themeData = (_themeData == lightMode) ? darkMode : lightMode;
  }

  bool isSoundOn = true;
  bool isMusicOn = true;
  final player = AudioPlayer();
  final sound1 = AssetSource('audio/cell_tap.wav');
  final sound2 = AssetSource('audio/local_win.wav');
  final sound3 = AssetSource('audio/global_win.wav');

  void tapSound() async {
    if (isSoundOn) {
      await player.play(
        sound1,
      );
    }
  }

  void localWinSound() async {
    if (isSoundOn) {
      await player.play(
        sound2,
      );
    }
  }

  void globalWinSound() async {
    if (isSoundOn) {
      await player.play(
        sound3,
      );
    }
  }
}
