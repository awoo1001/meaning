import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imagewordwise/meansentence.dart';
import 'package:imagewordwise/summary.dart'; // Add this import

class TextScreen extends StatefulWidget {
  final String text;
  
  const TextScreen({super.key, required this.text});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

final String texto="";
class _TextScreenState extends State<TextScreen> {
  @override
  void initState() {
    super.initState();
    printText();
  }

  void printText() {
    print(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracted Text'),
        backgroundColor: const Color.fromARGB(255, 255, 238, 2),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button for Vocabulary
                Column(
                  children: [
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded, 
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VocabularyScreen(texto: widget.text),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 5),
                    const Text('Vocabulary')
                  ],
                ),
                
                const SizedBox(width: 50),
                
                // Button for Summary
                Column(
                  children: [
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded, 
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SummaryPage(texto: widget.text),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 5),
                    const Text('Summary')
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
