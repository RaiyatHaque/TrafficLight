import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'traffic.dart';

// Map LightState to image assets
final imageMap = {
  LightState.G: 'assets/images/green.png',
  LightState.Y: 'assets/images/yellow.png',
  LightState.R: 'assets/images/red.png',
  LightState.N: 'assets/images/square.png',
};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Lights',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade800,
          toolbarHeight: 30,
          titleTextStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
          titleSpacing: 0,
          centerTitle: true,
        ),
      ),
      home: const MyHomePage(title: 'Traffic Lights'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TrafficLightState _gameState = TrafficLightState();

  void _processPress(int index) {
    setState(() {
      _gameState.playPosition(index);
    });
  }

  void _resetGame() {
    setState(() {
      _gameState = TrafficLightState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Colors.orange.shade600; // color-blind friendly accent
    final Color statusColor = Colors.blue.shade900;
    final Color resetColor = Colors.orange.shade600;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Text('Traffic Lights'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 800 / 3,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: TrafficLightState.cols,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: TrafficLightState.numCells,
                itemBuilder: (context, index) {
                  return Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(4),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: borderColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () => _processPress(index),
                      child: Image.asset(
                        imageMap[_gameState.board[index]] ?? 'assets/images/square.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                _gameState.isGameFinished()
                    ? (_gameState.winner == -1
                        ? "It's a draw!"
                        : "Player ${_gameState.winner} wins!")
                    : "Player ${_gameState.currentPlayer} to play.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Arial',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 28,
              child: TextButton(
                onPressed: _resetGame,
                style: TextButton.styleFrom(
                  foregroundColor: resetColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: resetColor,
                    letterSpacing: 1.1,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

