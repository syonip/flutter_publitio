import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_publitio/flutter_publitio.dart';
import 'package:flutter_publitio_example/video_player.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _url;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: _url == null
            ? Text('Waiting for url')
            : FlatButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VideoPlayer(
                          url: _url,
                        );
                      },
                    ),
                  );
                },
                child: const Text("Play"),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: _uploading
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Icon(Icons.add),
          onPressed: () async {
            // final response = await FlutterPublitio.uploadFile('');
            // setState(() {
            //   _url = response["url_preview"];
            // });

            final File videoFile =
                await ImagePicker.pickVideo(source: ImageSource.camera);

            if (videoFile == null) return;

            setState(() {
              _uploading = true;
              _url = null;
            });
            try {
              print('starting upload');
              final uploadOptions = {
                "privacy": "1",
                "option_download": "1",
                "option_transform": "1"
              };
              final response = await FlutterPublitio.uploadFile(
                  videoFile.path, uploadOptions);
              // If the widget was removed from the tree while the asynchronous platform
              // message was in flight, we want to discard the reply rather than calling
              // setState to update our non-existent appearance.
              print(response);
              print(response["url_preview"]);
              if (!mounted) return;

              setState(() {
                _uploading = false;
                _url = response["url_preview"];
              });
            } on PlatformException catch (e) {
              //TODO: show snackbar
              print(e.code);
              //result = 'Platform Exception: ${e.code} ${e.details}';
            }
          }),
    );
  }
}
