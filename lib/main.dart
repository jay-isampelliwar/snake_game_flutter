import 'dart:async';
import 'dart:math';

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
  List<int> _snake_Pos = [0, 1, 2];
  final _gridRow = 20;
  final _totalBlockPixels = 400;
  late int _foodLoaction = 55;
  var current_directin = Snake_Direction.RIGHT;
  int score = -1;

  bool hasGameStarted = false;

  @override
  void initState() {
    super.initState();
    eatFood();
  }

  _start_Game() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
        if (isGameOver()) {
          timer.cancel();

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: myText(text: "Game Over"),
                    content: MaterialButton(
                      onPressed: (() {
                        startNewGame();
                        Navigator.pop(context);
                      }),
                      child: myText(text: "Okay"),
                    ));
              });
        }
      });
    });
  }

  void startNewGame() {
    setState(() {
      _snake_Pos = [0, 1, 2];
      current_directin = Snake_Direction.RIGHT;
      hasGameStarted = false;
      score = -1;
      eatFood();
    });
  }

  bool isGameOver() {
    List<int> list = _snake_Pos.sublist(0, _snake_Pos.length - 1);

    if (list.contains(_snake_Pos.last)) {
      return true;
    } else {
      return false;
    }
  }

  eatFood() {
    score++;
    do {
      _foodLoaction = Random().nextInt(_totalBlockPixels);
    } while (_snake_Pos.contains(_foodLoaction));
  }

  moveSnake() {
    switch (current_directin) {
      case Snake_Direction.UP:
        {
          if (_snake_Pos.last < _gridRow) {
            _snake_Pos.add(_snake_Pos.last + _totalBlockPixels - _gridRow);
          } else {
            _snake_Pos.add(_snake_Pos.last - _gridRow);
          }

          if (_snake_Pos.contains(_snake_Pos.last - _gridRow)) {}
        }
        break;
      case Snake_Direction.RIGHT:
        {
          if (_snake_Pos.last % _gridRow == 19) {
            _snake_Pos.add(_snake_Pos.last + 1 - _gridRow);
          } else {
            _snake_Pos.add(_snake_Pos.last + 1);
          }
          if (_snake_Pos.contains(_snake_Pos.last + 1)) {}
        }
        break;
      case Snake_Direction.DOWN:
        {
          if (_snake_Pos.last < _totalBlockPixels &&
              _totalBlockPixels - _gridRow <= _snake_Pos.last) {
            _snake_Pos.add(_snake_Pos.last - (_totalBlockPixels - _gridRow));
          } else {
            _snake_Pos.add(_snake_Pos.last + _gridRow);
          }
          if (_snake_Pos.contains(_snake_Pos.last + _gridRow)) {}
        }
        break;
      case Snake_Direction.LEFT:
        {
          if (_snake_Pos.last % _gridRow == 0) {
            _snake_Pos.add(_snake_Pos.last - 1 + _gridRow);
          } else {
            _snake_Pos.add(_snake_Pos.last - 1);
          }
          if (_snake_Pos.contains(_snake_Pos.last - 1)) {}
        }
        break;
    }

    if (_foodLoaction == _snake_Pos.last) {
      eatFood();
    } else {
      _snake_Pos.removeAt(0);
    }
  }

  Widget myText({required String text}) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Center(child: myText(text: score.toString())),
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
                )),
            Expanded(
              child: Visibility(
                visible: !hasGameStarted,
                child: Center(
                  child: ElevatedButton(
                    onPressed: hasGameStarted
                        ? () {}
                        : () {
                            _start_Game();
                          },
                    style: ElevatedButton.styleFrom(primary: Colors.pink),
                    child: const Text("Start Game"),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
