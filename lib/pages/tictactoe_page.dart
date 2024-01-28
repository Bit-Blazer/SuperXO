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
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
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
}
