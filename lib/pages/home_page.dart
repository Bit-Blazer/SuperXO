import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superxo/pages/tictactoe_page.dart';
import 'package:superxo/pages/tictactoe_provider.dart';
import 'package:superxo/theme/theme.dart';
import 'package:superxo/theme/theme_provider.dart';

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
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(225, 75),
          ),
          icon: const Icon(CupertinoIcons.person_2_alt),
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
          label: const Text('Start Multiplayer'),
        ),
      ),
    );
  }
}
