import 'package:flutter/material.dart';

class TicTacToeNotifier extends ChangeNotifier {
  List<List<String>> board =
      List.generate(9, (_) => List.generate(9, (_) => ""));
  List<String> winners = List.generate(9, (_) => "");
  String currentPlayer = 'X';
  int activeGrid = -1;

  void tapAction(int gridIndex, int cellIndex, BuildContext context) {
    if (activeGrid == -1 || activeGrid == gridIndex) {
      if (board[gridIndex][cellIndex] == "") {
        board[gridIndex][cellIndex] = currentPlayer;
        if (_checkForWinner(gridIndex)) {
          winners[gridIndex] = currentPlayer;
          if (checkForOverallWinner()) {
            showWinnerDialog(currentPlayer, context);
          }
        }
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        activeGrid = winners[cellIndex] != "" ? -1 : cellIndex;
        notifyListeners();
      }
    }
  }

  bool isPlayableGrid(int gridIndex) {
    // bool isActiveGrid = (activeGrid == gridIndex ||(activeGrid != -1 && winners[activeGrid] != ""));
    bool isActiveGrid = (activeGrid == gridIndex);
    bool isWonGrid = activeGrid != -1 && winners[activeGrid] != "";

    if (activeGrid == -1 || isWonGrid) {
      // If the larger grid is won, highlight all smaller grids
      return true;
    } else {
      // Highlight the active smaller grid
      return isActiveGrid;
    }
  }

  bool _checkForWinner(int gridIndex) {
    // Check for a winner in the smaller grid
    for (int i = 0; i < 3; i++) {
      // Check rows
      if (board[gridIndex][i * 3] == board[gridIndex][i * 3 + 1] &&
          board[gridIndex][i * 3] == board[gridIndex][i * 3 + 2] &&
          board[gridIndex][i * 3] != "") {
        return true;
      }
      // Check columns
      if (board[gridIndex][i] == board[gridIndex][i + 3] &&
          board[gridIndex][i] == board[gridIndex][i + 6] &&
          board[gridIndex][i] != "") {
        return true;
      }
    }
    // Check diagonals
    if (board[gridIndex][0] == board[gridIndex][4] &&
        board[gridIndex][0] == board[gridIndex][8] &&
        board[gridIndex][0] != "") {
      return true;
    }
    if (board[gridIndex][2] == board[gridIndex][4] &&
        board[gridIndex][2] == board[gridIndex][6] &&
        board[gridIndex][2] != "") {
      return true;
    }
    return false;
  }

  bool checkForOverallWinner() {
    // Check for an overall winner across the main grid
    for (int i = 0; i < 3; i++) {
      // Check rows
      if (winners[i * 3] == winners[i * 3 + 1] &&
          winners[i * 3] == winners[i * 3 + 2] &&
          winners[i * 3] != "") {
        return true;
      }
      // Check columns
      if (winners[i] == winners[i + 3] &&
          winners[i] == winners[i + 6] &&
          winners[i] != "") {
        return true;
      }
    }
    // Check diagonals
    if (winners[0] == winners[4] &&
        winners[0] == winners[8] &&
        winners[0] != "") {
      return true;
    }
    if (winners[2] == winners[4] &&
        winners[2] == winners[6] &&
        winners[2] != "") {
      return true;
    }
    return false;
  }

  void showWinnerDialog(String winner, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '$winner WON',
            style: const TextStyle(
              fontFamily: 'Rammetto One',
            ),
          ),
          actions: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size(150, 50),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                "Play Again",
                style: TextStyle(
                  fontFamily: 'Rammetto One',
                ),
              ),
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    board = List.generate(9, (_) => List.generate(9, (_) => ""));
    winners = List.generate(9, (_) => "");
    currentPlayer = 'X';
    activeGrid = -1;
    notifyListeners();
  }
}
