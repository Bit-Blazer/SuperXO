import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../theme/theme.dart';
import '../theme/theme_provider.dart';
import 'tictactoe_page.dart';
import 'tictactoe_provider.dart';
import 'settings_page.dart';
import '../components/rounded_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SuperXO',
          style: TextStyle(
            fontFamily: 'Rammetto One',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeData == lightMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomRoundedButton(
              icon: CupertinoIcons.person_2_alt,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => TicTacToeNotifier(),
                      child: const TicTacToePage(),
                    ),
                  ),
                );
              },
              label: 'Start Multiplayer',
            ),
            const SizedBox(
              height: 75,
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
            const SizedBox(
              height: 75,
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