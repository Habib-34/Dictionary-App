import 'package:flutter/material.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> recentSearches = [
    'Quixotic',
    'Esoteric',
    'Godspeed',
    'Numinous',
    'Loquacious'
  ];

  void _searchWord(String word) {
    if (word.isNotEmpty && !recentSearches.contains(word)) {
      setState(() {
        recentSearches.insert(0, word);
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsScreen(word: word)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _searchWord,
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(recentSearches[index]),
                    onTap: () => _searchWord(recentSearches[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
