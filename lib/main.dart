import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(fixedSize: const Size(225, 75)),
          icon: const Icon(Icons.people),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TicTacToePage()),
            );
          },
          label: const Text('Start Multiplayer'),
        ),
      ),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<List<String>> board =
      List.generate(9, (_) => List.generate(9, (_) => ""));
  List<String> winners = List.generate(9, (_) => "");
  String currentPlayer = 'X';
  int activeGrid = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Tic-Tac-Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Player: $currentPlayer'),
            const SizedBox(height: 20),
            SizedBox(
              height: 375,
              width: 375,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 3.0)),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return Container(child: buildGrid(index));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: const Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(int gridIndex) {
    // for Outer Grid
    bool isActiveGrid = (activeGrid == gridIndex);
    Color borderColor = isActiveGrid ? Colors.blue : Colors.grey;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              color: borderColor, width: (isActiveGrid) ? 2.0 : 0.000004),
          right: BorderSide(
              color: borderColor,
              width: (gridIndex % 3 == 0 || gridIndex % 3 == 1 || isActiveGrid)
                  ? 2.0
                  : 0.000004),
          bottom: BorderSide(
              color: borderColor,
              width: (gridIndex < 6 || isActiveGrid) ? 2.0 : 0.000004),
          top: BorderSide(
              color: borderColor, width: (isActiveGrid) ? 2.0 : 0.000004),
        ),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return Container(child: buildGridCell(gridIndex, index));
        },
      ),
    );
  }

  Widget buildGridCell(int gridIndex, int cellIndex) {
    // for Inner Grid

    return GestureDetector(
      onTap: () {
        tapAction(gridIndex, cellIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
                color: Colors.black,
                width: (cellIndex % 3 == 0 || cellIndex % 3 == 1)
                    ? 2.0
                    : 0.000004),
            bottom: BorderSide(
                color: Colors.black, width: (cellIndex < 6) ? 2.0 : 0.000004),
          ),
        ),
        child: Center(
          child: Text(
            board[gridIndex][cellIndex],
            style: TextStyle(
                fontSize: 24.0,
                color: (board[gridIndex][cellIndex] == 'X'
                    ? Colors.red
                    : Colors.white70)),
          ),
        ),
      ),
    );
  }

  void tapAction(int gridIndex, int cellIndex) {
    if (activeGrid == -1 || activeGrid == gridIndex) {
      if (board[gridIndex][cellIndex] == "") {
        setState(() {
          board[gridIndex][cellIndex] = currentPlayer;
          if (_checkForWinner(gridIndex)) {
            winners[gridIndex] = currentPlayer;
            print("Player $currentPlayer wins in grid $gridIndex");
            if (_checkForOverallWinner()) {
              showWinner(currentPlayer);
            }
          }
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
          activeGrid = cellIndex;
        });
      }
    }
  }

  void _resetGame() {
    setState(() {
      board = List.generate(9, (_) => List.generate(9, (_) => ""));
      currentPlayer = 'X';
      activeGrid = -1;
    });
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

  bool _checkForOverallWinner() {
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

  void showWinner(String winner) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text('$winner WON'), actions: [
          ElevatedButton(
            child: const Text("Play Again"),
            onPressed: () {
              _resetGame();
              Navigator.of(context).pop();
            },
          )
        ]);
      },
    );
  }
}
