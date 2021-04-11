import 'package:flutter/material.dart';

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
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Stack(
        children: [
          Container(
            width: 200,
            height: 200,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 5,
            ),
          ),
          Image.network(
            _data['images']['downsized']['url'],
          ),
        ],
      )),
    );
  }
}
