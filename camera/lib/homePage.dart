import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  bool _uploaded = false;
  String _downloadUrl;
  String downloadMessage = 'Initializing...';
  bool _isDownloading = false;
  double _percentage = 0;
  Reference _reference = FirebaseStorage.instance.ref().child('myimage.jpg');

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      // ignore: deprecated_member_use
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
    });
  }

  Future uploadImage() async {
    UploadTask uploadTask = _reference.putFile(_imageFile);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => downloadImage());
    setState(() {
      _uploaded = true;
    });
  }

  Future downloadImage() async {
    String downloadAddress = await _reference.getDownloadURL();
    setState(() {
      _downloadUrl = downloadAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Camera App"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              ButtonTheme(
                minWidth: 200,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.orange,
                  child: Text('Gallery'),
                  onPressed: () {
                    getImage(true);
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              _imageFile == null
                  ? Container()
                  : Image.file(
                      _imageFile,
                      height: 300.0,
                      width: 300.0,
                    ),
              _imageFile == null
                  ? Container()
                  : RaisedButton(
                      color: Colors.orange,
                      child: Text("Upload to storage"),
                      onPressed: () {
                        uploadImage();
                      },
                    ),
              _uploaded == false
                  ? Container()
                  : RaisedButton(
                      color: Colors.green,
                      child: Text('Download Image'),
                      onPressed: () async {
                        var dir = await getExternalStorageDirectory();
                        downloadImage();
                        setState(() {
                          _isDownloading = !_isDownloading;
                        });

                        Dio dio = Dio();
                        dio.download('$_downloadUrl', '${dir.path}/sample.jpg',
                            onReceiveProgress: (actualbytes, totalbytes) {
                          var percentage = actualbytes / totalbytes * 100;
                          _percentage = percentage / 100;
                          setState(() {
                            downloadMessage =
                                'Downloads..${percentage.floor()} %';
                          });
                        });
                      },
                    ),
              SizedBox(height: 30),
              _uploaded == false
                  ? Container()
                  : Text(downloadMessage ?? '',
                      // ignore: deprecated_member_use
                      style: Theme.of(context).textTheme.headline),
              _downloadUrl == null ? Container() : Image.network(_downloadUrl),
              _downloadUrl == null
                  ? Container()
                  : LinearProgressIndicator(
                      value: _percentage,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
