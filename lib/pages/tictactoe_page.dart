import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/rounded_button.dart';
import '../providers/tictactoe_provider.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(
        milliseconds: 800,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TicTacToeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TicTacToe'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: -180 / 2,
                gravity: 0.1,
                numberOfParticles: 20,
                emissionFrequency: 0.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Current Player: '),
                  Image.asset(
                    prov.currentPlayer == CellState.X
                        ? 'assets/images/x.png'
                        : 'assets/images/o.png',
                    width: 20,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxWidth = constraints.maxWidth * 0.9;
                  double maxHeight = constraints.maxHeight * 0.9;
                  double squareSize =
                      maxWidth < maxHeight ? maxWidth : maxHeight;
                  return Container(
                    width: squareSize,
                    height: squareSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                        strokeAlign: 1.0,
                        color: Colors.grey,
                        width: 4.0,
                      ),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (prov.board[index] == CellState.empty) {
                              prov.tapAction(index);
                              if (prov.isWon || prov.isDraw) {
                                showWinnerDialog(prov);
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                strokeAlign: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                prov.board[index] == CellState.empty
                                    ? 'assets/images/-.png'
                                    : prov.board[index] == CellState.X
                                        ? 'assets/images/x.png'
                                        : 'assets/images/o.png',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            CustomRoundedButton(
              icon: CupertinoIcons.arrow_clockwise,
              label: 'Reset Game',
              onPressed: prov.resetGame,
            ),
          ],
        ),
      ),
    );
  }

  void showWinnerDialog(TicTacToeProvider prov) {
    if (prov.isWon) {
      _confettiController.play();
    }
    String asset = prov.isDraw
        ? 'assets/images/draw.png'
        : prov.currentPlayer == CellState.X
            ? 'assets/images/x.png'
            : 'assets/images/o.png';
    String text = prov.isDraw ? ' Game is Draw' : ' WON the Game';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  asset,
                  width: 30,
                ),
                Text(text),
              ],
            ),
          ),
          actions: [
            Center(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(),
                icon: const Icon(Icons.refresh),
                label: const Text('Play Again'),
                onPressed: () {
                  prov.resetGame();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}
