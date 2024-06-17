import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactic_app/winning_line.dart';
import 'package:audioplayers/audioplayers.dart';
import 'settings_screen.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<String> _board;
  late String _currentPlayer;
  late bool _gameOver;
  bool _isBusy = false;
  late SharedPreferences _prefs;
  Color? _xColor;
  Color? _oColor;
  Color? _boardColor;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeBoard();
    _loadPreferences();
  }

  void _initializeBoard() {
    _board = List.filled(9, '');
    _currentPlayer = 'X';
    _gameOver = false;
    _isBusy = false;
    _boardColor = Colors.black;
  }

  void _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _xColor = Color(_prefs.getInt('xColor') ?? Colors.green.value);
      _oColor = Color(_prefs.getInt('oColor') ?? Colors.red.value);
      _boardColor = Color(_prefs.getInt('boardColor') ?? Colors.black.value);
    });
  }

  void _handleTap(int index) async {
    if (!_gameOver && _board[index] == '' && !_isBusy) {
      await _playSound('tap_sound.mp3');
      setState(() {
        _board[index] = _currentPlayer;
        _isBusy = true;
      });

      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        if (_checkForWin()) {
          _playSound('win_sound.mp3');
          _showWinDialog();
          _gameOver = true;
        } else if (_board.every((element) => element != '')) {
          _playSound('lose_sound.mp3');
          _showDrawDialog();
          _gameOver = true;
        } else {
          _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
          _isBusy = false;
        }
      });
    }
  }

  Future<void> _playSound(String fileName) async {
    await _audioPlayer.play(AssetSource(fileName));
  }

  bool _checkForWin() {
    for (int i = 0; i < 9; i += 3) {
      if (_board[i] != '' &&
          _board[i] == _board[i + 1] &&
          _board[i + 1] == _board[i + 2]) {
        return true;
      }
    }
    for (int i = 0; i < 3; i++) {
      if (_board[i] != '' &&
          _board[i] == _board[i + 3] &&
          _board[i + 3] == _board[i + 6]) {
        return true;
      }
    }
    if (_board[0] != '' && _board[0] == _board[4] && _board[4] == _board[8]) {
      return true;
    }
    if (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6]) {
      return true;
    }
    return false;
  }

  void _showWinDialog() {
    List<int> winIndices = [];

    for (int i = 0; i < 9; i += 3) {
      if (_board[i] != '' &&
          _board[i] == _board[i + 1] &&
          _board[i + 1] == _board[i + 2]) {
        winIndices = [i, 1];
        break;
      }
    }
    for (int i = 0; i < 3; i++) {
      if (_board[i] != '' &&
          _board[i] == _board[i + 3] &&
          _board[i + 3] == _board[i + 6]) {
        winIndices = [i, 3];
        break;
      }
    }
    if (_board[0] != '' && _board[0] == _board[4] && _board[4] == _board[8]) {
      winIndices = [0, 4];
    }
    if (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6]) {
      winIndices = [2, 2];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal,
          title: const Text(
            'Game Over',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Player $_currentPlayer wins!',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              WinningLine(
                start: winIndices[0],
                step: winIndices[1],
                color: Colors.yellow,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _initializeBoard();
                });
              },
              child: const Text(
                'Play Again',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal,
          title: const Text(
            'Game Over',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'It\'s a draw!',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _initializeBoard();
                });
              },
              child: const Text(
                'Play Again',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updatePreferences() {
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        shadowColor: Colors.teal.shade900,
        title: const Text(
          'Tic Tac Toe Game',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onSettingsChanged: _updatePreferences,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    color: _boardColor,
                    child: Center(
                      child: Text(
                        _board[index],
                        style: TextStyle(
                          fontSize: 48.0,
                          color: _board[index] == 'X'
                              ? _xColor ?? Colors.black
                              : _oColor ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: _isBusy,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                'Player $_currentPlayer is choosing...',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
