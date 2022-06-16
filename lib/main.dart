import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/Blocks/empty_blocks.dart';
import 'package:snake_game/Blocks/snake.dart';
import 'package:snake_game/Blocks/food.dart';

void main(List<String> args) {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SnakeGame(),
    ),
  );
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

enum Snake_Direction { UP, RIGHT, DOWN, LEFT }

class _SnakeGameState extends State<SnakeGame> {
  final _snake_Pos = [0, 1, 2];
  final _gridRow = 10;
  final _totalBlockPixels = 100;
  late int _foodLoaction = 55;
  var current_directin = Snake_Direction.RIGHT;
  bool isGameOver = false;

  _start_Game() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
      });
    });
  }

  eatFood() {
    do {
      _foodLoaction = Random().nextInt(_totalBlockPixels);
    } while (_snake_Pos.contains(_foodLoaction));
  }

  moveSnake() {
    switch (current_directin) {
      case Snake_Direction.UP:
        {
          if (_snake_Pos.last < _gridRow) {
            _snake_Pos.add(_snake_Pos.last - _gridRow + _totalBlockPixels);
          } else {
            _snake_Pos.add(_snake_Pos.last - _gridRow);
          }

          if (_snake_Pos.contains(_snake_Pos.last - _gridRow)) {
            isGameOver = true;
            gameOver();
          }
        }
        break;
      case Snake_Direction.RIGHT:
        {
          if (_snake_Pos.last % _gridRow == 9) {
            _snake_Pos.add(_snake_Pos.last + 1 - _gridRow);
          } else {
            _snake_Pos.add(_snake_Pos.last + 1);
          }
          if (_snake_Pos.contains(_snake_Pos.last + 1)) {
            isGameOver = true;
            gameOver();
          }
        }
        break;
      case Snake_Direction.DOWN:
        {
          if (_snake_Pos.last + _gridRow > _totalBlockPixels) {
            _snake_Pos.add(_snake_Pos.last + _gridRow - _totalBlockPixels);
          } else {
            _snake_Pos.add(_snake_Pos.last + _gridRow);
          }
          if (_snake_Pos.contains(_snake_Pos.last + _gridRow)) {
            isGameOver = true;
            gameOver();
          }
        }
        break;
      case Snake_Direction.LEFT:
        {
          if (_snake_Pos.last % _gridRow == 0) {
            _snake_Pos.add(_snake_Pos.last - 1 + _gridRow);
          } else {
            _snake_Pos.add(_snake_Pos.last - 1);
          }
          if (_snake_Pos.contains(_snake_Pos.last - 1)) {
            isGameOver = true;
            gameOver();
          }
        }
        break;
    }

    if (_foodLoaction == _snake_Pos.last) {
      eatFood();
    } else {
      _snake_Pos.removeAt(0);
    }
  }

  Widget gameOver() {
    return Visibility(
        visible: isGameOver,
        child: const CupertinoAlertDialog(
          title: Text("Game Over"),
          content: Text("do you want yo play again"),
          actions: [
            CupertinoDialogAction(
              child: Text("No"),
            ),
            CupertinoDialogAction(
              child: Text("Yes"),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: gameOver(),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: ((details) {
                  if (details.delta.dy < 0 &&
                      current_directin != Snake_Direction.DOWN) {
                    current_directin = Snake_Direction.UP;
                  } else if (details.delta.dy > 0 &&
                      current_directin != Snake_Direction.UP) {
                    current_directin = Snake_Direction.DOWN;
                  }
                }),
                onHorizontalDragUpdate: ((details) {
                  if (details.delta.dx > 0 &&
                      current_directin != Snake_Direction.LEFT) {
                    current_directin = Snake_Direction.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      current_directin != Snake_Direction.RIGHT) {
                    current_directin = Snake_Direction.LEFT;
                  }
                }),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _totalBlockPixels,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridRow),
                  itemBuilder: (context, index) {
                    if (_snake_Pos.contains(index)) {
                      return const Snake();
                    } else if (index == _foodLoaction) {
                      return const Food();
                    } else {
                      return const Blocks();
                    }
                  },
                ),
              ),
            ),
            Expanded(
                child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _start_Game();
                },
                style: ElevatedButton.styleFrom(primary: Colors.pink),
                child: const Text("Start Game"),
              ),
            )),
          ],
        ));
  }
}
