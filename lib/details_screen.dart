import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class DetailsScreen extends StatefulWidget {
  final String word;

  const DetailsScreen({super.key, required this.word});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<Map<String, dynamic>> _fetchWordDetails() async {
    final response = await http.get(Uri.parse(
        'https://api.dictionaryapi.dev/api/v2/entries/en/${widget.word}'));
    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      throw Exception('Failed to load word details');
    }
  }

  void _playAudio(List<dynamic> phonetics) {
    for (var phonetic in phonetics) {
      if (phonetic['audio'] != null && phonetic['audio'].isNotEmpty) {
        _audioPlayer.play(UrlSource(phonetic['audio']));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchWordDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching word details'));
          } else {
            final details = snapshot.data!;
            final phonetics = details['phonetics'];
            final meanings = details['meanings'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Text(details['word'],
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => _playAudio(phonetics),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(details['phonetic'] ?? '',
                      style: const TextStyle(
                          fontSize: 18, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 20),
                  ...meanings.map<Widget>((meaning) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meaning['partOfSpeech'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          ...meaning['definitions']
                              .map<Widget>((def) => ListTile(
                                    title: Text(def['definition']),
                                    subtitle: Text(def['example'] ??
                                        'No example available'),
                                  )),
                          Text(
                            'Synonyms: ${meaning['synonyms'].join(', ')}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Antonyms: ${meaning['antonyms'].join(', ')}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
