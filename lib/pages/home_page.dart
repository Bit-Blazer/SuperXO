import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import '../theme/theme.dart';
import '../providers/app_provider.dart';
import 'super_tictactoe_page.dart';
import '../providers/super_tictactoe_provider.dart';
import 'tictactoe_page.dart';
import '../providers/tictactoe_provider.dart';
import 'settings_page.dart';
import '../components/rounded_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperXO'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<AppProvider>(context).themeData == lightMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomRoundedButton(
              icon: CupertinoIcons.person_2_alt,
              onPressed: () {
                SystemSound.play(SystemSoundType.click);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => SuperTicTacToeProvider(),
                      child: const SuperTicTacToePage(),
                    ),
                  ),
                );
              },
              label: 'Start Multiplayer',
            ),
            CustomRoundedButton(
              icon: CupertinoIcons.person_2_alt,
              onPressed: () {
                SystemSound.play(SystemSoundType.click);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => TicTacToeProvider(),
                      child: const TicTacToePage(),
                    ),
                  ),
                );
              },
              label: 'Normal TicTacToe',
            ),
            CustomRoundedButton(
              icon: CupertinoIcons.settings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              label: 'Settings',
            ),
            CustomRoundedButton(
              icon: Icons.exit_to_app_rounded,
              onPressed: () {
                SystemChannels.platform.invokeMapMethod('SystemNavigator.pop');
              },
              label: 'Exit',
            ),
          ],
        ),
      ),
    );
  }
}
