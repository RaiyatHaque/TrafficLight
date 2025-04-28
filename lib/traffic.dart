/// this code represents the state of a single light in the game
/// N-off G-green Y-yellow R-red
enum LightState { 
  N('-'), 
  G('G'), 
  Y('Y'), 
  R('R'); 

  final String symbol;
  const LightState(this.symbol);

  @override
  String toString() => symbol;
}


/// contains the game state and logic for the game
class TrafficLightState {

  static const rows = 4;
  static const cols = 3;
  static const numCells = rows * cols;
  

  //all the winning line index combinations(including rows, columns, diagonals)
  static const lines = [ 
  //horizontal lines
    [0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11],
  //vertical lines
    [0, 3, 6], [3, 6, 9],
    [1, 4, 7], [4, 7, 10],
    [2, 5, 8], [5, 8, 11],
  //diagonal lines
    [0, 4, 8], [3, 7, 11],
    [2, 4, 6], [5, 7, 9],
  ];

//current state 
  late List<LightState> board;  
//tells which player's turn it is
  late int currentPlayer;        
  //0-ongoing; if 1 or 2-winner; if -1-draw;
  late int winner;               
  //count the off-green moves made
  late int turns;                

  /// sets up a fresh game with all cells off and payer 1 has to move
  TrafficLightState()
      : board = List.filled(numCells, LightState.N),
        currentPlayer = 1,
        winner = 0,
        turns = 0;

  
  /// returns true only when game has ended
  bool isGameFinished() => winner != 0;

  /// plays the given cell index
  /// false when move is illegal or game over
  bool playPosition(int index) {
    if (index < 0 || index >= numCells || board[index] == LightState.R || isGameFinished()) {
      return false;
    }

    final previousState = board[index];

    // advance light from off-green-yellow-red
    board[index] = switch (board[index]) {
      LightState.N => LightState.G,
      LightState.G => LightState.Y,
      LightState.Y => LightState.R,
      LightState.R => LightState.R,
    };

 
    if (previousState == LightState.N) {
      turns++;
    }

   
    //check for a winner or draw
    _checkWinner();


    //switch player if game has not ended
    if (!isGameFinished()) {
      currentPlayer = (currentPlayer == 1 ? 2 : 1);
    }

    return true;
  }


  /// scans all winning lines and set winner to current player if it is found or -1 if its a draw(fully red with no winner)
  void _checkWinner() {
    for (final line in lines) {
      final a = board[line[0]];
      final b = board[line[1]];
      final c = board[line[2]];


      if (a != LightState.N && a == b && b == c) {
        winner = currentPlayer;
        return;
      }
    }

  
    if (_isBoardFullyRed() && winner == 0) {
      winner = -1;
    }
  }


  /// true if every cell is red and its a red
  bool _isBoardFullyRed() => board.every((light) => light == LightState.R);


  /// simple text representation of the board for debugging
  @override
  String toString() {
    final sb = StringBuffer();
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        sb.write('${board[i * cols + j]} ');
      }
      sb.write('\n');
    }
    return sb.toString();
  }
}

//runs predefined test cases
void main() {
  final testCases = [
    //horizontal win by player 1
    [0, 1, 2],          
    //vertical win by player 2
    [0, 3, 6, 1, 4, 7], 
    //full board which means draw
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 
    //diagonal win by player 1
    [0, 4, 8],          
    // vertical win by player 2
    [2, 5, 8, 1, 4, 7, 0, 3, 6], 
    // horizontal red win
    [3, 4, 5, 6, 7, 8, 9, 10, 11],
    // other diagonal win 
    [3, 7, 11, 2, 4, 6], 
  ];

  for (var i = 0; i < testCases.length; i++) {
    print('Running Test case ${i + 1}');
    final game = TrafficLightState();
    for (var move in testCases[i]) {
      game.playPosition(move);
      print(game);
      if (game.isGameFinished()) {
        final resultText = (game.winner == -1)
            ? 'Draw'
            : 'Player ${game.winner}';
        print('Game Over! Winner: $resultText');
        print('Test case ${i + 1} completed.\n');
        break;
      }
    }
  }
}
