import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum CellState {
  empty,
  X,
  O,
}

enum GridState {
  notWon,
  wonByX,
  wonByO,
  draw,
}

class AppProvider with ChangeNotifier {
  final player = AudioPlayer();
  List<List<CellState>> board =
      List.generate(9, (_) => List.filled(9, CellState.empty));
  List<GridState> winners = List.filled(9, GridState.notWon);
  CellState currentPlayer = CellState.X;
  int activeGrid = -1;
  bool isDraw = false;
  bool isWon = false;
  bool isSoundOn = true;
  bool isMusicOn = true;

  void tapAction(int gridIndex, int cellIndex) {
    board[gridIndex][cellIndex] = currentPlayer;
    if (checkForMiniGridWin(gridIndex)) {
      winners[gridIndex] =
          currentPlayer == CellState.X ? GridState.wonByX : GridState.wonByO;
      resetMiniGrid(gridIndex);
      isWon = checkForOverallGridWin();
      if (isWon) {
        globalWinSound();
      } else {
        localWinSound();
      }
    } else {
      tapSound();
    }
    if (!isWon) {
      currentPlayer = currentPlayer == CellState.X ? CellState.O : CellState.X;
      activeGrid = winners[cellIndex] != GridState.notWon &&
              winners[cellIndex] != GridState.draw
          ? -1
          : cellIndex;
    }
    notifyListeners();
  }

  bool isPlayableGrid(int gridIndex) {
    bool isActiveGrid = (activeGrid == gridIndex);
    bool isWonGrid =
        activeGrid != -1 && winners[activeGrid] != GridState.notWon;

    if (activeGrid == -1 || isWonGrid) {
      // If the larger grid is won, highlight all smaller grids
      return true;
    } else {
      // Highlight the active smaller grid
      return isActiveGrid;
    }
  }

  bool checkForMiniGridWin(int gridIndex) {
    // Check for a winner in the smaller grid
    for (int i = 0; i < 3; i++) {
      // Check rows
      if (board[gridIndex][i * 3] == board[gridIndex][i * 3 + 1] &&
          board[gridIndex][i * 3] == board[gridIndex][i * 3 + 2] &&
          board[gridIndex][i * 3] != CellState.empty) {
        return true;
      }
      // Check columns
      if (board[gridIndex][i] == board[gridIndex][i + 3] &&
          board[gridIndex][i] == board[gridIndex][i + 6] &&
          board[gridIndex][i] != CellState.empty) {
        return true;
      }
    }
    // Check diagonals
    if (board[gridIndex][0] == board[gridIndex][4] &&
        board[gridIndex][0] == board[gridIndex][8] &&
        board[gridIndex][0] != CellState.empty) {
      return true;
    }
    if (board[gridIndex][2] == board[gridIndex][4] &&
        board[gridIndex][2] == board[gridIndex][6] &&
        board[gridIndex][2] != CellState.empty) {
      return true;
    }
    if (checkForDraw(gridIndex)) {
      winners[gridIndex] = GridState.draw;
      resetMiniGrid(gridIndex);
      checkForOverallDraw();
    }
    return false;
  }

  bool checkForOverallGridWin() {
    // Check for an overall winner across the main grid
    for (int i = 0; i < 3; i++) {
      // Check rows
      if (winners[i * 3] == winners[i * 3 + 1] &&
          winners[i * 3] == winners[i * 3 + 2] &&
          winners[i * 3] != GridState.notWon) {
        return true;
      }
      // Check columns
      if (winners[i] == winners[i + 3] &&
          winners[i] == winners[i + 6] &&
          winners[i] != GridState.notWon) {
        return true;
      }
    }
    // Check diagonals
    if (winners[0] == winners[4] &&
        winners[0] == winners[8] &&
        winners[0] != GridState.notWon) {
      return true;
    }
    if (winners[2] == winners[4] &&
        winners[2] == winners[6] &&
        winners[2] != GridState.notWon) {
      return true;
    }
    checkForOverallDraw();
    return false;
  }

  bool checkForDraw(int gridIndex) {
    for (int i = 0; i < 9; i++) {
      if (board[gridIndex][i] == CellState.empty) {
        return false;
      }
    }
    return true;
  }

  void checkForOverallDraw() {
    isDraw = true;
    for (int i = 0; i < 9; i++) {
      if (winners[i] == GridState.notWon) {
        isDraw = false;
      }
    }
  }

  void resetGame() {
    board = List.generate(9, (_) => List.filled(9, CellState.empty));
    winners = List.filled(9, GridState.notWon);
    currentPlayer = CellState.X;
    activeGrid = -1;
    isDraw = false;
    isWon = false;
    notifyListeners();
  }

  void resetMiniGrid(int gridIndex) {
    for (int i = 0; i < 9; i++) {
      board[gridIndex][i] = CellState.empty;
    }
  }

  void tapSound() {
    if (isSoundOn) {
      player.stop();
      player.play(
        mode: PlayerMode.lowLatency,
        AssetSource('audio/cell_tap.wav'),
      );
    }
  }

  void localWinSound() {
    if (isSoundOn) {
      player.stop();
      player.play(
        mode: PlayerMode.lowLatency,
        AssetSource('audio/local_win.wav'),
      );
    }
  }

  void globalWinSound() {
    if (isSoundOn) {
      player.stop();
      player.play(
        mode: PlayerMode.lowLatency,
        AssetSource('audio/global_win.wav'),
      );
    }
  }
}
