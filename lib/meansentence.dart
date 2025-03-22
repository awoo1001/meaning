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
  final int maxWords = 7; // Limiting to 7 cards

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
            {"text": "Extract exactly 7 key vocabulary words with their meanings and example sentences from this text: ${widget.texto}. Format each word with its meaning on one line and the example on the next line, without using any special markdown or formatting."}
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
          // Ensure we have exactly 7 items or fewer
          vocabulary = vocabList.take(maxWords).toList();
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

  /// Improved parsing function to handle various formats including asterisks
  List<Map<String, String>> parseVocabulary(String responseText) {
    List<Map<String, String>> vocabList = [];
    // Replace all markdown formatting with plain text
    String cleanedText = responseText.replaceAll('**', '').replaceAll('*', '');
    List<String> lines = cleanedText.split("\n");
    
    String currentWord = "";
    String currentMeaning = "";
    String currentExample = "";
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty) continue;
      
      // Check if this is a new word entry (contains ":" and is likely word:meaning format)
      if (line.contains(":")) {
        // If we already have a word, save the previous entry
        if (currentWord.isNotEmpty) {
          vocabList.add({
            "word": currentWord,
            "meaning": currentMeaning,
            "example": currentExample,
          });
          
          // Reset for new word
          currentWord = "";
          currentMeaning = "";
          currentExample = "";
        }
        
        // Process new word and meaning
        List<String> parts = line.split(":");
        if (parts.length >= 2) {
          currentWord = parts[0].trim();
          // Join the rest as meaning in case there are multiple colons
          currentMeaning = parts.sublist(1).join(":").trim();
        }
      }
      // If not a word:meaning line and we have a current word, it's likely an example
      else if (currentWord.isNotEmpty && currentMeaning.isNotEmpty) {
        // Some APIs include "Example:" prefix, so remove it if present
        if (line.toLowerCase().startsWith("example:")) {
          currentExample = line.substring(8).trim();
        } else {
          currentExample = line.trim();
        }
      }
      
      // If we have all three components, add to list
      if (currentWord.isNotEmpty && currentMeaning.isNotEmpty && currentExample.isNotEmpty) {
        vocabList.add({
          "word": currentWord,
          "meaning": currentMeaning,
          "example": currentExample,
        });
        
        // Reset for next word
        currentWord = "";
        currentMeaning = "";
        currentExample = "";
      }
    }
    
    // Add the last word if we have one that wasn't added
    if (currentWord.isNotEmpty && currentMeaning.isNotEmpty) {
      vocabList.add({
        "word": currentWord,
        "meaning": currentMeaning,
        "example": currentExample.isEmpty ? "No example provided" : currentExample,
      });
    }

    return vocabList;
  }

  // Get gradient color for card based on index
  List<Color> getCardGradient(int index) {
    final List<List<Color>> gradients = [
      [Colors.blue.shade300, Colors.blue.shade600],
      [Colors.purple.shade300, Colors.purple.shade700],
      [Colors.teal.shade300, Colors.teal.shade700],
      [Colors.amber.shade300, Colors.amber.shade700],
      [Colors.pink.shade300, Colors.pink.shade700],
      [Colors.green.shade300, Colors.green.shade700],
      [Colors.indigo.shade300, Colors.indigo.shade700],
    ];
    
    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vocabulary Builder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber.shade300,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber.shade200, Colors.white],
          ),
        ),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.amber.shade700,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Finding key vocabulary...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : vocabulary.isEmpty
                    ? Center(
                        child: Text(
                          'No vocabulary words found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Key Vocabulary Words',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Swipe cards to explore',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: PageView.builder(
                                controller: PageController(viewportFraction: 0.85),
                                itemCount: vocabulary.length,
                                itemBuilder: (context, index) {
                                  final item = vocabulary[index];
                                  return _buildVocabCard(item, index);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
      ),
    );
  }

  Widget _buildVocabCard(Map<String, String> item, int index) {
    List<Color> gradientColors = getCardGradient(index);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          child: Column(
            children: [
              // Card header with word number
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Word ${index + 1} of ${vocabulary.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              
              // Card content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Word
                      Center(
                        child: Text(
                          item['word'] ?? '',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Meaning
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MEANING',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: gradientColors[1],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item['meaning'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Example
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXAMPLE',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: gradientColors[1],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item['example'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
