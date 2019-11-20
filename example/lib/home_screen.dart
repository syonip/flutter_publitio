import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_publitio/flutter_publitio.dart';
import 'package:flutter_publitio_example/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic _response = null;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_publitio example'),
      ),
      body: Center(
        child: _response == null
            ? Text('No video uploaded yet...')
            : Center(
                child: ListView(padding: const EdgeInsets.all(8), children: [
                  Text('Video thumbnail:', style: TextStyle(fontSize: 20)),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Center(child: CircularProgressIndicator()),
                      Center(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: _response["url_thumbnail"],
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return VideoPlayer(
                              url: _response["url_preview"],
                            );
                          },
                        ),
                      );
                    },
                    child: const Text("Play Video"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 40.0)),
                  Text('Server response:', style: TextStyle(fontSize: 20)),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text(_response.toString()),
                ]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: _uploading
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Icon(Icons.add),
          onPressed: () async {
            final File videoFile =
                await ImagePicker.pickVideo(source: ImageSource.camera);

            if (videoFile == null) return;

            setState(() {
              _uploading = true;
              _response = null;
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

              if (!mounted) return;

              setState(() {
                _uploading = false;
                _response = response;
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
