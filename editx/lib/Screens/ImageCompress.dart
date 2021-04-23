import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';

class ImageCompress extends StatefulWidget {
  @override
  _ImageCompressState createState() => _ImageCompressState();
}

class _ImageCompressState extends State<ImageCompress> {
  File _image;
  final picker = ImagePicker();
  double orignalSize = 0;
  double newSize = 0;
  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    orignalSize = await _image.length() / (1024);
    print(await _image.length());
    //print(orignalSize);
  }

  void compressImage(File file, int qty) async {
    // Get file path
    // eg:- "Volume/VM/abcd.jpeg"
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        minWidth: 1000, minHeight: 1000, quality: qty);
    setState(() {
      _image = File(compressedImage.path);
    });
    final paths = await path_provider.getExternalStorageDirectory();
    final p = paths.path.split('0')[0];
    final _appDocDir = '${p}0';
    final Directory _appDocDirFolder = Directory('${_appDocDir}/EditX/');
    if (await _appDocDirFolder.exists()) {
      await _image.copy(_appDocDirFolder.path + _image.path.split('/').last);
      Navigator.pop(context, _image);
    } else {
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      await _image.copy(_appDocDirNewFolder.path + _image.path.split('/').last);
      Navigator.pop(context, _image);
    }
  }

  double range = 50.00;
  @override
  Widget build(BuildContext context) {
    FlutterImageCompress.showNativeLog = true;
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Colors.orangeAccent, Colors.redAccent],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Compress Image'),
          centerTitle: true,
          actions: [
            _image != null
                ? IconButton(
                    icon: Icon(Icons.image_search_outlined),
                    onPressed: () {
                      getImage();
                    },
                  )
                : Container(),
          ],
        ),
        body: _image == null
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        alignment: Alignment.center,
                        iconSize: 100,
                        icon: Icon(
                          Icons.image_search_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          child: Image.file(_image),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text('Compress Value'),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Slider(
                                  value: range,
                                  onChanged: (nRange) async {
                                    newSize = orignalSize * nRange.toInt()/ 100;
                                    setState(() {
                                      range = nRange;
                                    });
                                    // print(range);
                                  },
                                  min: 0,
                                  max: 100,
                                  label: "$range",
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            '${range.toInt()} %',
                                            style: TextStyle(fontSize: 35),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              '${orignalSize.toInt()} KB',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'to',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              '${newSize.toInt()} KB',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 30,
                                      icon: Icon(Icons.save_alt),
                                      onPressed: () {
                                        compressImage(_image, range.toInt());
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
