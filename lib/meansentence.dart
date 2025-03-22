import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VocabularyScreen extends StatefulWidget {
  final String texto;

  VocabularyScreen({super.key, required this.texto});

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<Map<String, String>> vocabulary = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchGeminiData();
  }

  /// Fetches vocabulary-related data using Gemini API
  Future<void> fetchGeminiData() async {
    final String apiKey = ''; // Replace with your actual Gemini API key
    final String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';
    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": "Provide vocabulary words with their meanings and example sentences: ${widget.texto}"}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        // Extracting the generated text from Gemini API response
        String generatedText = responseData['candidates'][0]['content']['parts'][0]['text'];

        List<Map<String, String>> vocabList = parseVocabulary(generatedText);

        setState(() {
          vocabulary = vocabList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data from Gemini API');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  /// Parses text response from Gemini API into structured vocabulary data
  List<Map<String, String>> parseVocabulary(String responseText) {
    List<Map<String, String>> vocabList = [];
    List<String> lines = responseText.split("\n");

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains(":") && i + 1 < lines.length) {
        String word = lines[i].split(":")[0].trim();
        String meaning = lines[i].split(":")[1].trim();
        String example = lines[i + 1].trim();
        vocabList.add({"word": word, "meaning": meaning, "example": example});
      }
    }

    return vocabList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vocabulary List')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
                : ListView.builder(
                    itemCount: vocabulary.length,
                    itemBuilder: (context, index) {
                      final item = vocabulary[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['word']!,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text('Meaning: ${item['meaning']}',
                                  style: TextStyle(fontSize: 16, color: Colors.black87)),
                              SizedBox(height: 5),
                              Text('Example: "${item['example']}"',
                                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.blueGrey)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
