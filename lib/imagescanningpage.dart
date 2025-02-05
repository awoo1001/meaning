import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'recognisingscreen.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        
        children: [
          
          Column(
            children: [
             
             // Image.asset("assets/ocr.png"),
            ],
          ),
          SizedBox(height: 390),
          Row(
            
            children: [
               SizedBox(width: 39),
              Container(
                height: 77,
                width: 324,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 12, 86, 99),
                  borderRadius: BorderRadius.circular(20.0), 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        XFile? xfile = await imagePicker.pickImage(source: ImageSource.camera);
                        if (xfile != null) {
                          File image = File(xfile.path);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecogniseImage(imagee: image)),
                          );
                        }
                      },
                    ),
                    InkWell(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        XFile? xfile = await imagePicker.pickImage(source: ImageSource.gallery);
                        if (xfile != null) {
                          File image = File(xfile.path);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecogniseImage(imagee: image)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
