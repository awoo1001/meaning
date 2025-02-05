import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class textscren extends StatefulWidget {
  String textt;
   textscren({
    super.key,
    required this.textt
    });

  @override
  State<textscren> createState() => _textscrenState();
}

class _textscrenState extends State<textscren> {

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
          
      body: Column(
        children: [
         
         SizedBox(height: 20),
      
                Text(widget.textt,
                style: TextStyle(
                 fontSize: 20.0
                ),
                ),

        ],
      ),
    );
  }
}