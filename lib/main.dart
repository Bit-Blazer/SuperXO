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
  String currentPlayer = 'X';

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
              height: 400,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return buildGrid(index);
                },
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
    return GridView.builder(
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemBuilder: (context, index) {
        return buildGridCell(gridIndex, index);
      },
    );
  }

  Widget buildGridCell(int gridIndex, int cellIndex) {
    return GestureDetector(
      onTap: () {
        tapAction(gridIndex, cellIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Center(
          child: Text(
            board[gridIndex][cellIndex],
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  void tapAction(int gridIndex, int cellIndex) {
    if (board[gridIndex][cellIndex] == "") {
      setState(() {
        board[gridIndex][cellIndex] = currentPlayer;
        _checkForWinner(gridIndex, cellIndex);
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });
      // Add your game logic here, check for a win, update the turn, etc.
    }
  }

  void _resetGame() {
    setState(() {
      board = List.generate(9, (_) => List.generate(9, (_) => ""));
      currentPlayer = 'X';
    });
  }

  void _checkForWinner(row, col) {
    // Implement the logic to check for a winner in the smaller grid
    // and update the overall game state accordingly.
    // You may need to check for a winner in the larger grid as well.
  }
}
