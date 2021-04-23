import 'dart:io';

import 'package:editx/Screens/VideoCompressProgress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_compress/video_compress.dart';

class VideoCompressor extends StatefulWidget {
  @override
  _VideoCompressorState createState() => _VideoCompressorState();
}

class _VideoCompressorState extends State<VideoCompressor> {
  File _video;
  String qty = 'NONE';
  Subscription _subscription;
  VideoPlayerController _videoPlayerController;
  double ev = 0.00;
  bool isCompress = false;
  bool isDone = false;
  String p = 'null';
  bool isFilePicked = false;
  double nSize = 0.00;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subscription = VideoCompress.compressProgress$.subscribe((event) {
      //print('Iamjack56----------------------------------------------');
      setState(() {
        ev = event;
      });
    });
  }

  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
  }

  final picker = ImagePicker();
  Future<void> _getVideo() async {
    final video = await picker.getVideo(source: ImageSource.gallery);
    _video = File(video.path);
    setState(() {
      isFilePicked = false;
    });
    _videoPlayerController = new VideoPlayerController.file(_video)
      ..initialize().then(
        (_) {
          setState(() {
            isFilePicked = true;
          });
          _videoPlayerController.pause();
        },
      );
  }

  void _startVideoCompression(String type) async {
    print(type);
    if (type == 'NONE') {
      print('Hwllo');
      showDialog(
          context: context,
          builder: (_) => _alertDialouge('Please Select Compress Quality.'));
      return;
    } else {
      setState(() {
        isCompress = true;
      });
      final path = await VideoCompress.compressVideo(
        _video.path,
        quality: type == 'LOW'
            ? VideoQuality.LowQuality
            : type == 'MEDIUM'
                ? VideoQuality.MediumQuality
                : VideoQuality.HighestQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      final paths = await getExternalStorageDirectory();
      final p1 = paths.path.split('0')[0];
      final _appDocDir = '${p1}0';
      File vdo = File(path.path);
      nSize = await vdo.length() / 1024;
      final Directory _appDocDirFolder = Directory('${_appDocDir}/EditX/');
      if (await _appDocDirFolder.exists()) {
        await vdo.copy(_appDocDirFolder.path + vdo.path.split('/').last);
        setState(() {
          isCompress = false;
          isDone = true;
          p = path.path;
        });
      } else {
        final Directory _appDocDirNewFolder =
            await _appDocDirFolder.create(recursive: true);
        await vdo.copy(_appDocDirNewFolder.path + vdo.path.split('/').last);
        setState(() {
          isCompress = false;
          isDone = true;
          p = path.path;
        });
      }
    }
  }

  Widget _alertDialouge(String msg) {
    return AlertDialog(
      title: Text('Error !'),
      content: Text(msg),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'))
      ],
      elevation: 3,
    );
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
          title: Text('Compress Video'),
          centerTitle: true,
          actions: [
            _video != null
                ? IconButton(
                    icon: Icon(Icons.image_search_outlined),
                    onPressed: () async {
                      isDone = false;
                      isCompress = false;
                      isFilePicked = false;
                      await _getVideo();
                    },
                  )
                : Container(),
          ],
        ),
        body: _video == null
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
                          Icons.video_library_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _getVideo();
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
                          child: isFilePicked
                              ? _videoPlayerController.value.initialized
                                  ? AspectRatio(
                                      aspectRatio: _videoPlayerController
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(_videoPlayerController),
                                    )
                                  : Container()
                              : Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: isCompress
                          ? Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: LinearProgressIndicator(
                                      value: ev,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        '${ev.toInt()} %',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : isDone
                              ? Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          'Compress Completed',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Text(
                                              'Path:- /storage/emulated/0/EditX/' +
                                                  p.split('/').last),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        child: Center(
                                            child: Text(
                                                'New Size:- ${nSize.toInt()} KB')),
                                      ),
                                      Center(
                                        child: FlatButton(
                                          color: Colors.orangeAccent,
                                          onPressed: () {
                                            setState(() {
                                              isCompress = false;
                                              isDone = false;
                                              _video = null;
                                            });
                                          },
                                          child: Text('Done'),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                RaisedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      qty = 'LOW';
                                                    });
                                                  },
                                                  child: Text(
                                                    'Low',
                                                  ),
                                                ),
                                                RaisedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      qty = 'MEDIUM';
                                                    });
                                                  },
                                                  child: Text('Medium'),
                                                ),
                                                RaisedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      qty = 'HIGH';
                                                    });
                                                  },
                                                  child: Text('High'),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '${qty}',
                                                    style:
                                                        TextStyle(fontSize: 35),
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 30,
                                                  icon: Icon(Icons.save_alt),
                                                  onPressed: () {
                                                    _startVideoCompression(qty);
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
