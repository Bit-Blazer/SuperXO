import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum CellState { empty, X, O }

enum GridState { notWon, wonByX, wonByO, draw }

class SuperTicTacToeProvider with ChangeNotifier {
  final player = AudioPlayer();
  final sound1 = AssetSource('audio/cell_tap.wav');
  final sound2 = AssetSource('audio/local_win.wav');
  final sound3 = AssetSource('audio/global_win.wav');

  List<List<CellState>> board = List.generate(
    9,
    (_) => List.filled(9, CellState.empty),
  );
  List<GridState> winners = List.filled(9, GridState.notWon);
  CellState currentPlayer = CellState.X;
  int activeGrid = -1;
  bool isDraw = false;
  bool isWon = false;
  bool isSoundOn = true;
  bool isSinglePlayer = false; // Default to two player mode

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
      activeGrid = winners[cellIndex] != GridState.notWon ? -1 : cellIndex;

      // If single player mode is on and it's AI's turn (O)
      if (isSinglePlayer && currentPlayer == CellState.O && !isWon && !isDraw) {
        // Add a small delay for a more natural feel
        Future.delayed(const Duration(milliseconds: 500), () {
          makeAIMove();
        });
      }
    }
    notifyListeners();
  }

  void makeAIMove() {
    if (isWon || isDraw) return;

    // Find and make the best move
    final (gridIndex, cellIndex) = findBestMove();

    // Execute the AI move
    if (gridIndex != -1 && cellIndex != -1) {
      tapAction(gridIndex, cellIndex);
    }
  }

  (int, int) findBestMove() {
    // Start with a random strategy
    final random = Random();
    List<(int, int)> availableMoves = [];

    // Identify playable grid(s)
    List<int> playableGrids = [];
    if (activeGrid == -1) {
      // All unfinished grids are playable
      for (int i = 0; i < 9; i++) {
        if (winners[i] == GridState.notWon) {
          playableGrids.add(i);
        }
      }
    } else {
      // Only the active grid is playable
      playableGrids.add(activeGrid);
    }

    // First priority: Win any miniGrid if possible
    for (int gridIndex in playableGrids) {
      final winningMove = findWinningMove(gridIndex, CellState.O);
      if (winningMove != -1) {
        return (gridIndex, winningMove);
      }
    }

    // Second priority: Block opponent from winning any miniGrid
    for (int gridIndex in playableGrids) {
      final blockingMove = findWinningMove(gridIndex, CellState.X);
      if (blockingMove != -1) {
        return (gridIndex, blockingMove);
      }
    }

    // Third priority: Make a strategic move
    // 1. Prefer center of available grids
    for (int gridIndex in playableGrids) {
      if (board[gridIndex][4] == CellState.empty) {
        return (gridIndex, 4);
      }
    }

    // 2. Prefer corners
    List<int> corners = [0, 2, 6, 8];
    for (int gridIndex in playableGrids) {
      for (int corner in corners) {
        if (board[gridIndex][corner] == CellState.empty) {
          return (gridIndex, corner);
        }
      }
    }

    // Collect all available moves
    for (int gridIndex in playableGrids) {
      for (int cellIndex = 0; cellIndex < 9; cellIndex++) {
        if (board[gridIndex][cellIndex] == CellState.empty) {
          availableMoves.add((gridIndex, cellIndex));
        }
      }
    }

    // If no strategic move is found, make a random move
    if (availableMoves.isNotEmpty) {
      final randomIndex = random.nextInt(availableMoves.length);
      return availableMoves[randomIndex];
    }

    // No valid moves
    return (-1, -1);
  }

  int findWinningMove(int gridIndex, CellState playerSymbol) {
    // Check for winning moves in rows
    for (int row = 0; row < 3; row++) {
      if (checkWinningLine(
        gridIndex,
        row * 3,
        (row * 3) + 1,
        (row * 3) + 2,
        playerSymbol,
      )) {
        return row * 3 +
            findEmptyInLine(gridIndex, row * 3, (row * 3) + 1, (row * 3) + 2);
      }
    }

    // Check for winning moves in columns
    for (int col = 0; col < 3; col++) {
      if (checkWinningLine(gridIndex, col, col + 3, col + 6, playerSymbol)) {
        return col + 3 * findEmptyInLine(gridIndex, col, col + 3, col + 6);
      }
    }

    // Check for winning move in diagonals
    if (checkWinningLine(gridIndex, 0, 4, 8, playerSymbol)) {
      return [0, 4, 8][findEmptyInLine(gridIndex, 0, 4, 8)];
    }

    if (checkWinningLine(gridIndex, 2, 4, 6, playerSymbol)) {
      return [2, 4, 6][findEmptyInLine(gridIndex, 2, 4, 6)];
    }

    return -1; // No winning move found
  }

  bool checkWinningLine(
    int gridIndex,
    int a,
    int b,
    int c,
    CellState playerSymbol,
  ) {
    int count = 0;
    int empty = 0;

    if (board[gridIndex][a] == playerSymbol) count++;
    if (board[gridIndex][a] == CellState.empty) empty++;

    if (board[gridIndex][b] == playerSymbol) count++;
    if (board[gridIndex][b] == CellState.empty) empty++;

    if (board[gridIndex][c] == playerSymbol) count++;
    if (board[gridIndex][c] == CellState.empty) empty++;

    // If we have two of player's symbols and one empty slot, this is a winning move
    return count == 2 && empty == 1;
  }

  int findEmptyInLine(int gridIndex, int a, int b, int c) {
    if (board[gridIndex][a] == CellState.empty) return 0;
    if (board[gridIndex][b] == CellState.empty) return 1;
    if (board[gridIndex][c] == CellState.empty) return 2;
    return -1; // Should never happen if checkWinningLine returns true
  }

  void setGameMode(bool isSinglePlayerMode) {
    isSinglePlayer = isSinglePlayerMode;
    resetGame();
  }

  bool isPlayableGrid(int gridIndex) {
    bool isActiveGrid = (activeGrid == gridIndex);
    if (activeGrid == -1 && winners[gridIndex] == GridState.notWon) {
      // If the a grid is won, highlight all grids that are not won
      return true;
    } else {
      // Highlight the active grid
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

  void tapSound() async {
    if (isSoundOn) {
      await player.play(sound1);
    }
  }

  void localWinSound() async {
    if (isSoundOn) {
      await player.play(sound2);
    }
  }

  void globalWinSound() async {
    if (isSoundOn) {
      await player.play(sound3);
    }
  }
}
