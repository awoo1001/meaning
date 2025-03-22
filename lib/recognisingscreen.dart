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
  String textt = "";

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    Future.microtask(() => dotextrecognition());
  }

  Future<void> dotextrecognition() async {
    final InputImage inputImage = InputImage.fromFile(widget.imagee);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      textt = recognizedText.text;
    });

    print(textt);
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recognized Text'),
        backgroundColor: const Color.fromARGB(255, 255, 238, 2),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            Center(
              child: Image.file(widget.imagee),
            ),
            const SizedBox(height: 130),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: const Icon(Icons.arrow_forward_rounded, size: 40),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TextScreen(text: textt),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
