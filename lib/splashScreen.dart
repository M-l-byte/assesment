import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/bgsplash.jpg'), // Replace with your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WELCOME !!!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GridInputScreen()),
                  );
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridInputScreen extends StatefulWidget {
  @override
  _GridInputScreenState createState() => _GridInputScreenState();
}

class _GridInputScreenState extends State<GridInputScreen> {
  TextEditingController mController = TextEditingController();
  TextEditingController nController = TextEditingController();
  TextEditingController alphabetsController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  List<List<String>> grid = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 242, 232),
      appBar: AppBar(
        title: const Text(
          'Grid Input',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: mController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter m'),
            ),
            TextField(
              controller: nController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter n'),
            ),
            TextField(
              controller: alphabetsController,
              decoration: const InputDecoration(labelText: 'Enter Alphabets'),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                createGrid();
              },
              child: const Text(
                'Create Grid',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createGrid() {
    int m = int.parse(mController.text);
    int n = int.parse(nController.text);

    List<String> alphabets = alphabetsController.text.split('');

    grid = List.generate(
      m,
      (i) => List.generate(
        n,
        (j) => alphabets[(i * n + j) % alphabets.length],
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GridDisplayScreen(
            grid: grid, searchTextController: searchTextController),
      ),
    );
  }
}

class GridDisplayScreen extends StatefulWidget {
  final List<List<String>> grid;

  GridDisplayScreen(
      {required this.grid,
      required TextEditingController searchTextController});

  @override
  State<GridDisplayScreen> createState() => _GridDisplayScreenState();
}

class _GridDisplayScreenState extends State<GridDisplayScreen> {
  final TextEditingController searchTextController = TextEditingController();
  List<List<TextSpan>> styledGrid = [];

  @override
  void initState() {
    super.initState();
    initializeStyledGrid();
  }

  void initializeStyledGrid() {
    // Initialize the styledGrid with the same dimensions as the original grid
    styledGrid = List.generate(
      widget.grid.length,
      (i) => List.generate(
        widget.grid[i].length,
        (j) => TextSpan(
          text: widget.grid[i][j],
          style: TextStyle(
              color: Colors.blue.shade300, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 242, 232),
      appBar: AppBar(
        title: Text('Grid Display'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grid:',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            for (int i = 0; i < widget.grid.length; i++)
              Row(
                children: [
                  for (int j = 0; j < widget.grid[i].length; j++)
                    GestureDetector(
                      onTap: () {
                        _toggleHighlight(i, j);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: styledGrid[i][j],
                        ),
                      ),
                    ),
                ],
              ),
            TextField(
              controller: searchTextController,
              decoration:
                  const InputDecoration(labelText: 'Enter Text to Search'),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                searchText();
              },
              child: Text('Search Text'),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleHighlight(int row, int col) {
    setState(() {
      styledGrid[row][col] = TextSpan(
        text: widget.grid[row][col],
        style: TextStyle(color: Colors.red),
      );
    });
  }

  void searchText() {
    String textToSearch = searchTextController.text;
    print('Searching for: $textToSearch');
    _searchWordInGrid(textToSearch);
  }

  void _searchWordInGrid(String word) {
    int row = widget.grid.length;
    int col = widget.grid[0].length;
    if (_checkWordAtPosition(widget.grid, word, row, col)) {
      print('found!!');
      return;
    }
    print("not found");
  }

  bool _checkWordAtPosition(
      List<List<String>> grid, String word, int row, int col) {
    int ind = 0;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (grid[i][j] == word[ind]) {
          if (_search(grid, word, i, j, ind, row, col)) {
            _highlightWord(word, i, j);
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _search(List<List<String>> grid, String word, int i, int j, int ind,
      int row, int col) {
    if (ind == word.length) return true;
    if (i < 0 ||
        j < 0 ||
        i == row ||
        j == col ||
        grid[i][j] != word[ind] ||
        grid[i][j] == '!') return false;
    String c = grid[i][j];
    grid[i][j] = "!";
    bool top = _search(grid, word, i - 1, j, ind + 1, row, col);
    bool right = _search(grid, word, i, j + 1, ind + 1, row, col);
    bool bottom = _search(grid, word, i + 1, j, ind + 1, row, col);
    bool left = _search(grid, word, i, j - 1, ind + 1, row, col);
    bool diagonal = _search(grid, word, i + 1, j + 1, ind, row, col);

    grid[i][j] = c;

    return top || bottom || right || left || diagonal;
  }

  void _highlightWord(String word, int row, int col) {
    for (int i = 0; i < word.length; i++) {
      _toggleHighlight(row, col + i);
    }
  }
}
