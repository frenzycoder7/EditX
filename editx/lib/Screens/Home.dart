import 'dart:io';

import 'package:flutter/material.dart';
import './ImageEditor/image_editor_pro.dart';
import './../Widget/index.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  void _handleImageEdit() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageEditorPro(
        appBarColor: Colors.orangeAccent,
        bottomBarColor: Colors.orangeAccent,
      );
    })).then((geteditimage) {
      if (geteditimage != null) {
        setState(() {
          _image = geteditimage;
        });
      }
    }).catchError((er) {
      print(er);
    });
  }

  void _handleImageCompress() async {
    Navigator.of(context).pushNamed('/img-compress');
  }

  void _handleVideoCompress() async {
    Navigator.of(context).pushNamed('/vdo-compress');
  }

  void _handleCropImage() async {
    Navigator.of(context).pushNamed('/crop-image');
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Colors.orangeAccent, Colors.redAccent],
        ),
      ),
      child: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shadowColor: Colors.grey,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _drawerKey.currentState?.openDrawer();
              }),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.crop_rotate_outlined,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ItemsF(
                            name: 'Image Edit',
                            icon: Icons.image_rounded,
                            onTap: _handleImageEdit,
                          ),
                          ItemsF(
                            name: 'Image Crop',
                            icon: Icons.crop_outlined,
                            onTap: _handleCropImage,
                          ),
                          ItemsF(
                            name: 'Image Compress',
                            icon: Icons.image_not_supported_sharp,
                            onTap: _handleImageCompress,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ItemsF(
                              name: 'Filters', icon: Icons.filter_1_outlined),
                          ItemsF(
                            name: 'Video Compress',
                            icon: Icons.video_settings_outlined,
                            onTap: _handleVideoCompress,
                          ),
                          ItemsF(
                            name: 'Video Edit',
                            icon: Icons.video_library,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          elevation: 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.orangeAccent, Colors.redAccent],
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          'EditX',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '1.0.1',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: ListTile(
                    leading: Icon(Icons.save_alt),
                    title: Text(
                      'Save Path',
                      style: TextStyle(color: Colors.grey),
                    ),
                    subtitle: Text(
                      '/storage/emulated/0/EditX/',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: ListTile(
                    leading: Icon(Icons.star_border_outlined),
                    title: Text(
                      'Rate this app',
                      style: TextStyle(color: Colors.grey),
                    ),
                    //subtitle: Text('/storage/emulated/0/EditX/',style:TextStyle(color: Colors.grey),),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: ListTile(
                    leading: Icon(Icons.message),
                    title: Text(
                      'Feedback',
                      style: TextStyle(color: Colors.grey),
                    ),
                    //subtitle: Text('/storage/emulated/0/EditX/',style:TextStyle(color: Colors.grey),),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text(
                      'Share',
                      style: TextStyle(color: Colors.grey),
                    ),
                    //subtitle: Text('/storage/emulated/0/EditX/',style:TextStyle(color: Colors.grey),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
