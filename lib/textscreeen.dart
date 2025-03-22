import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imagewordwise/meansentence.dart';

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
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            widget.text,
            style: const TextStyle(fontSize: 20.0),
          ),

          InkWell(
           child: const Icon(Icons.arrow_forward_rounded, size: 40),
          onTap: ()
          {
                 Navigator.push(context,MaterialPageRoute(builder: (context)=>VocabularyScreen(texto:widget.text)),);
          } 
          )
        ],
      ),
    );
  }
}
