import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game_button.dart';
import 'package:tic_tac_toe/costum_dialog.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GameButton> buttonsList;
  List<int> player1 = [];
  List<int> player2 = [];
  int activePlayer = 1;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    activePlayer = 1;
    return List.generate(9, (i) => GameButton(id: i + 1));
  }

  void playGame(GameButton gb) {
    setState(() {
      gb.text = activePlayer == 1 ? "X" : "0";
      gb.bg = activePlayer == 1 ? Colors.red : Colors.black;
      gb.enabled = false;

      if (activePlayer == 1) {
        player1.add(gb.id);
        activePlayer = 2;
      } else {
        player2.add(gb.id);
        activePlayer = 1;
      }

      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text.isNotEmpty)) {
          showDialog(
            context: context,
            builder: (_) => CustomDialog("Game Tied", "Press the reset button to start again.",
                resetGame),
          );
        } else if (activePlayer == 2) {
          autoPlay();
        }
      }
    });
  }

  void autoPlay() {
    List<int> emptyCells = List.generate(9, (i) => i + 1)
        .where((cellID) => !player1.contains(cellID) && !player2.contains(cellID))
        .toList();

    if (emptyCells.isNotEmpty) {
      int cellID = emptyCells[Random().nextInt(emptyCells.length)];
      int i = buttonsList.indexWhere((p) => p.id == cellID);
      playGame(buttonsList[i]);
    }
  }

  int checkWinner() {
    const List<List<int>> winningCombinations = [
      [1, 2, 3], [4, 5, 6], [7, 8, 9], // rows
      [1, 4, 7], [2, 5, 8], [3, 6, 9], // columns
      [1, 5, 9], [3, 5, 7],           // diagonals
    ];

    for (var combination in winningCombinations) {
      if (player1.toSet().containsAll(combination)) {
        showDialog(
          context: context,
          builder: (_) => CustomDialog("Player X Won", "Press the reset button to start again.", resetGame),
        );
        return 1;
      } else if (player2.toSet().containsAll(combination)) {
        showDialog(
          context: context,
          builder: (_) => CustomDialog("Player O Won", "Press the reset button to start again.", resetGame),
        );
        return 2;
      }
    }
    return -1;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
      player1.clear();
      player2.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Tic Tac Toe"))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius:BorderRadius.circular(12)
                ),
                child: Center(
                  child: Text('Palyer X', style:
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                  ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:BorderRadius.circular(12)
                ),
                child: Center(
                  child: Text('Palyer O', style:
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                  ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50,),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 9.0,
                mainAxisSpacing: 9.0,
              ),
              itemCount: buttonsList.length,
              itemBuilder: (context, i) => SizedBox(
                width: 100.0,
                height: 100.0,
                child: ElevatedButton(
                  onPressed: buttonsList[i].enabled ? () => playGame(buttonsList[i]) : null,
                  child: Text(buttonsList[i].text, style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonsList[i].bg,
                    disabledBackgroundColor: buttonsList[i].bg,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            child: Text("Reset", style: TextStyle(color: Colors.white, fontSize: 20.0)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: resetGame,
          ),
        ],
      ),
    );
  }
}
