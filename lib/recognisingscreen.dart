import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:imagewordwise/textscreeen.dart';

class RecogniseImage extends StatefulWidget {
  final File imagee;

  const RecogniseImage({
    Key? key,
    required this.imagee,
  }) : super(key: key);

  @override
  State<RecogniseImage> createState() => _RecogniseImageState();
}

class _RecogniseImageState extends State<RecogniseImage> {

  late TextRecognizer textRecognizer;
  @override
  void initState() {
      
      textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      dotextrecognition();
    super.initState();
  }


String text="";
  dotextrecognition() async
  {
      InputImage inputImage=InputImage.fromFile(this.widget.imagee);
      
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    //  print(recognizedText);

String text = recognizedText.text;

print(text);
//print("object");

for (TextBlock block in recognizedText.blocks) {
  final Rect rect = block.boundingBox;
  final List<Point<int>> cornerPoints = block.cornerPoints;
  final String text = block.text;
  final List<String> languages = block.recognizedLanguages;

  for (TextLine line in block.lines) {
    // Same getters as TextBlock
    for (TextElement element in line.elements) {
      // Same getters as TextBlock
    }
  }
}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' '),
        backgroundColor: Color.fromARGB(255, 255, 238, 2),
      ),
      body: Column(
        children: [
          SizedBox(height: 70),
          Center(
            child: Image.file(widget.imagee), 
          ),
         
         SizedBox(height: 130),
          
          Row(
            children: [
              SizedBox(width: 334),

              InkWell(
                child: Icon(Icons.arrow_forward_rounded,
                size: 40),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>textscren(textt:text)));
                },
              ),
              
            ],
          )
        ],
      ),
    );
  }
}
