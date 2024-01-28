import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CustomRoundedButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(250, 20),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              width: 4,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                label.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
