import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageCropScreen extends StatefulWidget {
  @override
  _ImageCropScreenState createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final rootPath = '/storage/emulated/0/EditX/';
  File _image;
  final picker = ImagePicker();
  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Image Croper',
        toolbarColor: Colors.orangeAccent,
        statusBarColor: Colors.orangeAccent,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        backgroundColor: Colors.orangeAccent,
      ),
      iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          showCancelConfirmationDialog: true,
          rectHeight: 600,
          rectWidth: double.infinity),
      
    );
    await saveCroppedImage(croppedFile, croppedFile.path.split('/').last);
  }

  Future<void> saveCroppedImage(File image,String name) async {
      try {
        final Directory root = Directory(rootPath);
        if (await root.exists()) {
          await image.copy(root.path +
              name);
          Navigator.pop(context, image);
        } else {
          final Directory _appDocDirNewFolder =
              await root.create(recursive: true);
          await image.copy(_appDocDirNewFolder.path +
              name);
          Navigator.pop(context, image);
        }
      } catch (e) {
        print(e);
      }
    }
  @override
  Widget build(BuildContext context) {
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
            title: Text('Crop Image'),
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
          body: Container(
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
          )),
    );
  }
}
