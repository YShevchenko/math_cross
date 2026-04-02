import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(const MathCrossApp());

class MathCrossApp extends StatelessWidget {
  const MathCrossApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Cross',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.deepOrange,
          secondary: Colors.deepOrangeAccent,
        ),
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('➕ Math Cross'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDifficultyButton(context, 'Easy', 3),
            const SizedBox(height: 16),
            _buildDifficultyButton(context, 'Medium', 5),
            const SizedBox(height: 16),
            _buildDifficultyButton(context, 'Hard', 7),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String label, int size) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GameScreen(gridSize: size)),
        );
      },
      child: Text('$label (${size}x$size)'),
    );
  }
}

enum CellType { empty, number, operator, equals, input }

class GridCell {
  final CellType type;
  final String? value; // For fixed numbers and operators
  int? userInput; // For input cells

  GridCell({required this.type, this.value, this.userInput});

  GridCell copyWith({int? userInput}) {
    return GridCell(
      type: type,
      value: value,
      userInput: userInput ?? this.userInput,
    );
  }
}

class PuzzleGenerator {
  static List<List<GridCell>> generate(int size) {
    final grid = List.generate(
      size,
      (i) => List.generate(size, (j) => GridCell(type: CellType.empty)),
    );

    if (size == 3) {
      return _generate3x3();
    } else if (size == 5) {
      return _generate5x5();
    } else {
      return _generate7x7();
    }
  }

  static List<List<GridCell>> _generate3x3() {
    // Pattern: 3 + 2 = 5
    //          + + +
    //          1 + 4 = 5
    return [
      [
        GridCell(type: CellType.input, userInput: null), // 3
        GridCell(type: CellType.operator, value: '+'),
        GridCell(type: CellType.input, userInput: null), // 2
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.number, value: '5'),
      ],
      [
        GridCell(type: CellType.operator, value: '+'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.operator, value: '+'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.operator, value: '+'),
      ],
      [
        GridCell(type: CellType.number, value: '1'),
        GridCell(type: CellType.operator, value: '+'),
        GridCell(type: CellType.input, userInput: null), // 4
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.number, value: '5'),
      ],
      [
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.equals, value: '='),
      ],
      [
        GridCell(type: CellType.number, value: '4'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.number, value: '6'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.number, value: '10'),
      ],
    ];
  }

  static List<List<GridCell>> _generate5x5() {
    // Pattern: 5 + 3 = 8
    //          - - -
    //          2 - 1 = 1
    //          = = =
    //          3 2 7
    return [
      [
        GridCell(type: CellType.input, userInput: null), // 5
        GridCell(type: CellType.operator, value: '+'),
        GridCell(type: CellType.input, userInput: null), // 3
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.number, value: '8'),
      ],
      [
        GridCell(type: CellType.operator, value: '-'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.operator, value: '-'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.operator, value: '-'),
      ],
      [
        GridCell(type: CellType.number, value: '2'),
        GridCell(type: CellType.operator, value: '-'),
        GridCell(type: CellType.input, userInput: null), // 1
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.number, value: '1'),
      ],
      [
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.equals, value: '='),
      ],
      [
        GridCell(type: CellType.number, value: '3'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.number, value: '2'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.number, value: '7'),
      ],
    ];
  }

  static List<List<GridCell>> _generate7x7() {
    // Pattern: 8 * 2 = 16
    //          + + +
    //          4 + 6 = 10
    //          = = =
    //          12 8 26
    return [
      [
        GridCell(type: CellType.input, userInput: null), // 8
        GridCell(type: CellType.operator, value: '*'),
        GridCell(type: CellType.input, userInput: null), // 2
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.number, value: '16'),
      ],
      [
        GridCell(type: CellType.operator, value: '+'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.operator, value: '+'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.operator, value: '+'),
      ],
      [
        GridCell(type: CellType.input, userInput: null), // 4
        GridCell(type: CellType.operator, value: '+'),
        GridCell(type: CellType.input, userInput: null), // 6
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.number, value: '10'),
      ],
      [
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.equals, value: '='),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.equals, value: '='),
      ],
      [
        GridCell(type: CellType.number, value: '12'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.number, value: '8'),
        GridCell(type: CellType.empty),
        GridCell(type: CellType.number, value: '26'),
      ],
    ];
  }

  static Map<String, int> getSolution(int size) {
    if (size == 3) {
      return {'0-0': 3, '0-2': 2, '2-2': 4}; // row-col: answer
    } else if (size == 5) {
      return {'0-0': 5, '0-2': 3, '2-2': 1};
    } else {
      return {'0-0': 8, '0-2': 2, '2-0': 4, '2-2': 6};
    }
  }
}

class GameScreen extends StatefulWidget {
  final int gridSize;

  const GameScreen({super.key, required this.gridSize});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<GridCell>> grid;
  late Map<String, int> solution;
  int? selectedRow;
  int? selectedCol;
  late DateTime startTime;
  int elapsedSeconds = 0;
  Timer? timer;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    grid = PuzzleGenerator.generate(widget.gridSize);
    solution = PuzzleGenerator.getSolution(widget.gridSize);
    startTime = DateTime.now();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isCompleted) {
        setState(() {
          elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _selectCell(int row, int col) {
    if (grid[row][col].type == CellType.input) {
      setState(() {
        selectedRow = row;
        selectedCol = col;
      });
    }
  }

  void _inputNumber(int number) {
    if (selectedRow != null && selectedCol != null) {
      setState(() {
        grid[selectedRow!][selectedCol!] = grid[selectedRow!][selectedCol!].copyWith(userInput: number);
        _checkCompletion();
      });
    }
  }

  void _clearCell() {
    if (selectedRow != null && selectedCol != null) {
      setState(() {
        grid[selectedRow!][selectedCol!] = grid[selectedRow!][selectedCol!].copyWith(userInput: null);
      });
    }
  }

  void _checkCompletion() {
    bool allFilled = true;
    bool allCorrect = true;

    for (var entry in solution.entries) {
      final parts = entry.key.split('-');
      final row = int.parse(parts[0]);
      final col = int.parse(parts[1]);
      final cell = grid[row][col];

      if (cell.userInput == null) {
        allFilled = false;
        break;
      }

      if (cell.userInput != entry.value) {
        allCorrect = false;
      }
    }

    if (allFilled && allCorrect) {
      setState(() {
        isCompleted = true;
        timer?.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Puzzle Complete!')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉 Well Done!', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 24),
              Text('Time: ${elapsedSeconds}s', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Menu'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Time: ${elapsedSeconds}s')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                    ),
                    itemCount: 25,
                    itemBuilder: (context, index) {
                      final row = index ~/ 5;
                      final col = index % 5;
                      final cell = grid[row][col];
                      final isSelected = selectedRow == row && selectedCol == col;

                      return GestureDetector(
                        onTap: () => _selectCell(row, col),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: _getCellColor(cell, isSelected),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.deepOrange : Colors.grey.shade800,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _getCellText(cell),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _getTextColor(cell),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Tap a cell, then select a number:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (int i = 1; i <= 9; i++)
                      ElevatedButton(
                        onPressed: () => _inputNumber(i),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(60, 60),
                        ),
                        child: Text('$i', style: const TextStyle(fontSize: 24)),
                      ),
                    ElevatedButton(
                      onPressed: _clearCell,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(60, 60),
                        backgroundColor: Colors.red.shade900,
                      ),
                      child: const Icon(Icons.backspace, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCellColor(GridCell cell, bool isSelected) {
    if (isSelected) return Colors.deepOrange.shade900;
    if (cell.type == CellType.input) return Colors.blueGrey.shade800;
    if (cell.type == CellType.empty) return Colors.grey.shade900;
    return Colors.grey.shade800;
  }

  Color _getTextColor(GridCell cell) {
    if (cell.type == CellType.input) return Colors.white;
    if (cell.type == CellType.operator) return Colors.deepOrangeAccent;
    if (cell.type == CellType.equals) return Colors.greenAccent;
    return Colors.white70;
  }

  String _getCellText(GridCell cell) {
    if (cell.type == CellType.input) {
      return cell.userInput?.toString() ?? '';
    }
    return cell.value ?? '';
  }
}
