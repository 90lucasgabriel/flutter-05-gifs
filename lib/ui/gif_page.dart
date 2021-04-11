import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class GifPage extends StatelessWidget {
  final Map _data;
  GifPage(this._data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            _data['title'],
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(_data['images']['downsized']['url']);
              },
            )
          ]),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5,
                ),
              ),
            ),
            Center(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _data['images']['downsized']['url'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
