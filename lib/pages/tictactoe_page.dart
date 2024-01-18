import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../components/rounded_button.dart';
import 'tictactoe_provider.dart';

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
    final ticTacToeNotifier = Provider.of<TicTacToeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MultiPlayer',
          style: TextStyle(
            fontFamily: 'Rammetto One',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: -pi / 2,
                gravity: 0.1,
                numberOfParticles: 20,
                emissionFrequency: 0.2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Current Player: ',
                  style: TextStyle(
                    fontFamily: 'Rammetto One',
                  ),
                ),
                Image.asset(
                  ticTacToeNotifier.currentPlayer == "X"
                      ? 'assets/x.png'
                      : 'assets/o.png',
                  width: 15,
                  alignment: Alignment.bottomLeft,
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 375,
              width: 375,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 3.0,
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
                        if (ticTacToeNotifier.winners[index] != "") {
                          return Stack(
                            children: [
                              Container(
                                child: buildGrid(index, ticTacToeNotifier),
                              ),
                              Image.asset(
                                ticTacToeNotifier.winners[index] == "X"
                                    ? 'assets/x.png'
                                    : 'assets/o.png',
                                width: 115,
                                alignment: Alignment.bottomLeft,
                              ),
                            ],
                          );
                        } else {
                          return Stack(
                            children: [
                              Container(
                                child: buildGrid(index, ticTacToeNotifier),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomRoundedButton(
              icon: CupertinoIcons.arrow_clockwise,
              label: 'Reset Game',
              onPressed: ticTacToeNotifier.resetGame,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(int gridIndex, TicTacToeNotifier ticTacToeNotifier) {
    // for Outer Grid
    bool isPlayable = ticTacToeNotifier.isPlayableGrid(gridIndex);
    Color borderColor = isPlayable ? Colors.blue : Colors.grey;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: (isPlayable) ? 2.0 : 0.000004,
          ),
          right: BorderSide(
            color: borderColor,
            width: (gridIndex % 3 == 0 || gridIndex % 3 == 1 || isPlayable)
                ? 2.0
                : 0.000004,
          ),
          bottom: BorderSide(
            color: borderColor,
            width: (gridIndex < 6 || isPlayable) ? 2.0 : 0.000004,
          ),
          top: BorderSide(
            color: borderColor,
            width: (isPlayable) ? 2.0 : 0.000004,
          ),
        ),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return Container(
            child: buildGridCell(gridIndex, index, ticTacToeNotifier),
          );
        },
      ),
    );
  }

  Widget buildGridCell(
    int gridIndex,
    int cellIndex,
    TicTacToeNotifier ticTacToeNotifier,
  ) {
    // for Inner Grid

    return GestureDetector(
      onTap: () {
        ticTacToeNotifier.tapAction(gridIndex, cellIndex, context);
        if (ticTacToeNotifier.checkForOverallWinner()) {
          _confettiController.play();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.black,
              width:
                  (cellIndex % 3 == 0 || cellIndex % 3 == 1) ? 2.0 : 0.000004,
            ),
            bottom: BorderSide(
              color: Colors.black,
              width: (cellIndex < 6) ? 2.0 : 0.000004,
            ),
          ),
        ),
        child: Center(
          child: Text(
            ticTacToeNotifier.board[gridIndex][cellIndex],
            style: TextStyle(
              fontSize: 24.0,
              color: (ticTacToeNotifier.board[gridIndex][cellIndex] == 'X')
                  ? Colors.red
                  : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
