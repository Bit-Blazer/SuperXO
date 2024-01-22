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
    final prov = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiPlayer'),
        centerTitle: true,
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(elevation: 0),
            label: const Text('Rules'),
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Rules'),
                    content: const SingleChildScrollView(
                      child: Text(
                        '''1. Game Board Structure:
- The game board is a 3x3 grid, where each cell represents a smaller Tic-Tac-Toe board.
2. Player Moves:
- On their turn, a player places their symbol (X or O) in an empty cell of the smaller Tic-Tac-Toe board.
3. Sequential Local Board Selection:
- The cell in the local board where a player makes a move determines the local board on which the next player must play.
4. Player Options:
- The next player can choose to play in any cell within the local board that the previous player selected.
5. Winning a Local Board:
- To win a local board, a player must achieve three symbols in a row, either horizontally, vertically, or diagonally within that board.
6. Game Objective:
- The ultimate goal is to win three local boards consecutively.''',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
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
                const Text('Current Player: '),
                Image.asset(
                  prov.currentPlayer == 'X'
                      ? 'assets/images/x.png'
                      : 'assets/images/o.png',
                  width: 15,
                  alignment: Alignment.center,
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 375,
              width: 375,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 3.0,
                  ),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    if (prov.winners[index] != '') {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            child: buildGrid(index, prov),
                          ),
                          Image.asset(
                            prov.winners[index] == 'D'
                                ? 'assets/images/draw.png'
                                : prov.winners[index] == 'X'
                                    ? 'assets/images/x.png'
                                    : 'assets/images/o.png',
                            width: 115,
                            alignment: Alignment.center,
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        child: buildGrid(index, prov),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
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

  Widget buildGrid(int gridIndex, AppProvider ticTacToeNotifier) {
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
    AppProvider ticTacToeNotifier,
  ) {
    // for Inner Grid

    return GestureDetector(
      onTap: () {
        if (ticTacToeNotifier.board[gridIndex][cellIndex] == '' &&
            (ticTacToeNotifier.activeGrid == -1 ||
                ticTacToeNotifier.activeGrid == gridIndex)) {
          ticTacToeNotifier.tapAction(gridIndex, cellIndex);
          if (ticTacToeNotifier.isWon) {
            showWinnerDialog(
              ticTacToeNotifier.currentPlayer,
              ticTacToeNotifier,
            );
            _confettiController.play();
          } else if (ticTacToeNotifier.isDraw) {
            showWinnerDialog('Draw', ticTacToeNotifier);
          }
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
          child: Image.asset(
            ticTacToeNotifier.board[gridIndex][cellIndex] == ''
                ? 'assets/images/-.png'
                : ticTacToeNotifier.board[gridIndex][cellIndex] == 'X'
                    ? 'assets/images/x.png'
                    : 'assets/images/o.png',
            alignment: Alignment.center,
            width: 35,
          ),
        ),
      ),
    );
  }

  void showWinnerDialog(String winner, AppProvider ticTacToeNotifier) {
    if (winner == 'Draw') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text('Game is Draw'),
            ),
            actions: [
              Center(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Play Again'),
                  onPressed: () {
                    ticTacToeNotifier.resetGame();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowAlignment: OverflowBarAlignment.center,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    winner == 'X'
                        ? 'assets/images/x.png'
                        : 'assets/images/o.png',
                    width: 30,
                    alignment: Alignment.center,
                  ),
                  const Text(' WON the Game'),
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
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowAlignment: OverflowBarAlignment.center,
          );
        },
      );
    }
  }
}
