import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/super_tictactoe_provider.dart';

class SuperTicTacToePage extends StatefulWidget {
  const SuperTicTacToePage({super.key});

  @override
  State<SuperTicTacToePage> createState() => _SuperTicTacToePageState();
}

class _SuperTicTacToePageState extends State<SuperTicTacToePage>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _boardAnimationController;
  late AnimationController _playerTurnController;
  late Animation<double> _boardScaleAnimation;
  late Animation<double> _playerIndicatorAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 800),
    );

    _boardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _playerTurnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _boardScaleAnimation = CurvedAnimation(
      parent: _boardAnimationController,
      curve: Curves.easeOutBack,
    );

    _playerIndicatorAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _playerTurnController, curve: Curves.easeInOut),
    );

    _boardAnimationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
    _boardAnimationController.dispose();
    _playerTurnController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SuperTicTacToeProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Super TicTacToe',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'Game Rules',
            onPressed: () => _showRulesDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(),
              colorScheme.surface,
              colorScheme.surface,
              colorScheme.secondaryContainer.withValues(),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Confetti effect
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  blastDirection: -pi / 2,
                  gravity: 0.1,
                  numberOfParticles: 20,
                  emissionFrequency: 0.2,
                ),
              ),

              Column(
                children: [
                  // Player turn & game mode
                  _buildGameInfoSection(prov, colorScheme),

                  // Game board
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ScaleTransition(
                        scale: _boardScaleAnimation,
                        child: Center(
                          child: _buildGameBoard(prov, colorScheme),
                        ),
                      ),
                    ),
                  ),

                  // Game controls
                  _buildGameControls(prov, colorScheme),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameInfoSection(
    SuperTicTacToeProvider prov,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          // Current player indicator
          ScaleTransition(
            scale: _playerIndicatorAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    prov.currentPlayer == CellState.X
                        ? Colors.blue.withAlpha((0.2 * 255).toInt())
                        : Colors.red.withAlpha((0.2 * 255).toInt()),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      prov.currentPlayer == CellState.X
                          ? Colors.blue
                          : Colors.red,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    width: 30,
                    prov.currentPlayer == CellState.X
                        ? 'assets/images/x.png'
                        : 'assets/images/o.png',
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Turn',
                        style: TextStyle(
                          color: colorScheme.onSurface.withAlpha(
                            (0.7 * 255).toInt(),
                          ),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        prov.isSinglePlayer
                            ? (prov.currentPlayer == CellState.X
                                ? 'Your Turn'
                                : 'Thinking...')
                            : (prov.currentPlayer == CellState.X
                                ? 'Player X'
                                : 'Player O'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard(SuperTicTacToeProvider prov, ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;
        double squareSize = maxWidth < maxHeight ? maxWidth : maxHeight;

        return Container(
          width: squareSize,
          height: squareSize,
          decoration: BoxDecoration(
            border: Border.all(
              strokeAlign: 1.0,
              color: Colors.grey,
              width: 3.0,
            ),
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.onSurface.withAlpha((0.2 * 255).toInt()),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9,
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildOuterGrid(index, prov, colorScheme),
                    if (prov.winners[index] != GridState.notWon)
                      _buildWinnerOverlay(prov.winners[index]),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildOuterGrid(
    int gridIndex,
    SuperTicTacToeProvider prov,
    ColorScheme colorScheme,
  ) {
    bool isPlayable = prov.isPlayableGrid(gridIndex);
    Color borderColor =
        isPlayable
            ? colorScheme.primary
            : colorScheme.onSurface.withAlpha((0.2 * 255).toInt());

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color:
            isPlayable
                ? colorScheme.primaryContainer.withAlpha((0.3 * 255).toInt())
                : colorScheme.surface,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        padding: const EdgeInsets.all(4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return _buildInnerGridCell(gridIndex, index, prov, colorScheme);
        },
      ),
    );
  }

  Widget _buildInnerGridCell(
    int gridIndex,
    int cellIndex,
    SuperTicTacToeProvider prov,
    ColorScheme colorScheme,
  ) {
    final isPlayable =
        (prov.activeGrid == -1 || prov.activeGrid == gridIndex) &&
        prov.board[gridIndex][cellIndex] == CellState.empty &&
        !(prov.isSinglePlayer && prov.currentPlayer == CellState.O);

    return GestureDetector(
      onTap:
          isPlayable
              ? () {
                //  _showWinnerDialog(prov);
                prov.tapAction(gridIndex, cellIndex);
                if (prov.isWon || prov.isDraw) {
                  _showWinnerDialog(prov);
                }
              }
              : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Colors.black,
          //   width: 2.0,
          // ),
          color:
              isPlayable
                  ? colorScheme.primary.withAlpha((0.1 * 255).toInt())
                  : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: _buildCellContent(prov.board[gridIndex][cellIndex], colorScheme),
      ),
    );
  }

  Widget _buildCellContent(CellState state, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        state == CellState.empty
            ? 'assets/images/-.png'
            : state == CellState.X
            ? 'assets/images/x.png'
            : 'assets/images/o.png',
      ),
    );
  }

  Widget _buildWinnerOverlay(GridState state) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(
        state == GridState.draw
            ? 'assets/images/draw.png'
            : state == GridState.wonByX
            ? 'assets/images/x.png'
            : 'assets/images/o.png',
      ),
    );
  }

  Widget _buildGameControls(
    SuperTicTacToeProvider prov,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            onPressed: prov.resetGame,
            icon: Icons.refresh,
            label: 'Reset Game',
          ),
          _buildControlButton(
            onPressed: () => prov.setGameMode(!prov.isSinglePlayer),
            icon: prov.isSinglePlayer ? Icons.people : Icons.computer,
            label: prov.isSinglePlayer ? 'Two Player' : 'VS Computer',
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text('Game Rules'),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRuleItem(
                  '1. Board Structure',
                  'The game board is a 3×3 grid of smaller Tic-Tac-Toe boards.',
                  Icons.grid_3x3,
                ),
                _buildRuleItem(
                  '2. Player Moves',
                  'On your turn, place your symbol (X or O) in any empty cell of the active smaller board.',
                  Icons.touch_app,
                ),
                _buildRuleItem(
                  '3. Next Board Selection',
                  'The cell position you choose determines which small board your opponent must play in next.',
                  Icons.arrow_forward,
                ),
                _buildRuleItem(
                  '4. Active Board',
                  'Highlighted boards are active - you must play in the board that corresponds to the position of your opponent"s last move.',
                  Icons.highlight,
                ),
                _buildRuleItem(
                  '5. Winning Small Boards',
                  'Win a small board by creating a line of three of your symbols horizontally, vertically, or diagonally.',
                  Icons.star,
                ),
                _buildRuleItem(
                  '6. Game Objective',
                  'Win the game by winning three small boards in a line (horizontally, vertically, or diagonally).',
                  Icons.emoji_events,
                ),
                _buildRuleItem(
                  '7. Free Choice',
                  'If your opponent sends you to a board thats already been won or is full, you can play in any board.',
                  Icons.face,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRuleItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWinnerDialog(SuperTicTacToeProvider prov) {
    if (prov.isWon) {
      _confettiController.play();
    }
    String asset;
    String text;

    if (prov.isDraw) {
      text = "It's a Draw!";
      asset = 'assets/images/draw.png';
    } else {
      asset =
          prov.currentPlayer == CellState.X
              ? 'assets/images/x.png'
              : 'assets/images/o.png';
      if (prov.isSinglePlayer) {
        if (prov.currentPlayer == CellState.X) {
          text = 'You Won!';
        } else {
          text = 'Computer Won!';
        }
      } else {
        text = ' WON the Game!';
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(asset, width: 30), Text(text)],
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
