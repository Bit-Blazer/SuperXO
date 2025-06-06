import 'package:flutter/material.dart';

enum CellState { empty, X, O }

class TicTacToeProvider with ChangeNotifier {
  List<CellState> board = List.filled(9, CellState.empty);
  CellState currentPlayer = CellState.X;
  bool isWon = false;
  bool isDraw = false;
  bool isSinglePlayer = false; // Default to two player mode

  void tapAction(int index) {
    board[index] = currentPlayer;
    isWon = checkForWin();
    if (!isWon) {
      currentPlayer = currentPlayer == CellState.X ? CellState.O : CellState.X;
    }
    notifyListeners();
  }

  void resetGame() {
    board = List.filled(9, CellState.empty);
    currentPlayer = CellState.X;
    notifyListeners();
  }
  void setGameMode(bool isSinglePlayerMode) {
    isSinglePlayer = isSinglePlayerMode;
    resetGame();
  }
  bool checkForWin() {
    for (int i = 0; i < 3; i++) {
      // Check rows
      if (board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2] &&
          board[i * 3] != CellState.empty) {
        return true;
      }
      // Check columns
      if (board[i] == board[i + 3] &&
          board[i] == board[i + 6] &&
          board[i] != CellState.empty) {
        return true;
      }
    }
    // Check diagonals
    if (board[0] == board[4] &&
        board[0] == board[8] &&
        board[0] != CellState.empty) {
      return true;
    }
    if (board[2] == board[4] &&
        board[2] == board[6] &&
        board[2] != CellState.empty) {
      return true;
    }
    checkForDraw();
    return false;
  }

  void checkForDraw() {
    isDraw = true;
    for (int i = 0; i < 9; i++) {
      if (board[i] == CellState.empty) {
        isDraw = false;
      }
    }
  }
}
