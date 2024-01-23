import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_provider.dart';
import '../components/rounded_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SwitchListTile(
                    thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> states) {
                        return prov.isMusicOn
                            ? const Icon(Icons.music_note)
                            : const Icon(Icons.music_off);
                      },
                    ),
                    secondary: Icon(
                      prov.isMusicOn ? Icons.music_note : Icons.music_off,
                    ),
                    value: prov.isMusicOn,
                    title: const Text('Music'),
                    onChanged: (bool value) {
                      setState(() {
                        prov.isMusicOn = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> states) {
                        return prov.isSoundOn
                            ? const Icon(Icons.graphic_eq)
                            : const Icon(Icons.volume_off);
                      },
                    ),
                    secondary: Icon(
                      prov.isSoundOn ? Icons.graphic_eq : Icons.volume_off,
                    ),
                    value: prov.isSoundOn,
                    title: const Text('Sound'),
                    onChanged: (bool value) {
                      setState(() {
                        prov.isSoundOn = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            CustomRoundedButton(
              icon: CupertinoIcons.arrow_left_circle_fill,
              label: 'Go Back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
