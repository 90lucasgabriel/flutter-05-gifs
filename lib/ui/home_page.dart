import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:gifs/ui/gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _baseUrl = 'https://api.giphy.com/v1/gifs';
  String _key = 'xWcllBt57Hq8lJrAbw5fMafEn5RRNvj3';
  int _limit = 27;

  TextEditingController _keywordController = TextEditingController();
  int _offset = 0;

  Future<http.Response> _request() async {
    Uri requestTrending =
        Uri.parse('$_baseUrl/trending?api_key=$_key&limit=$_limit&rating=g');
    Uri requestSearch = Uri.parse(
        '$_baseUrl/search?api_key=$_key&q=${_keywordController.text}&limit=$_limit&offset=$_offset&rating=g&lang=en');

    if (_keywordController.text.isEmpty) {
      return http.get(requestTrending);
    }

    return http.get(requestSearch);
  }

  Future<Map> _getGifList() async {
    http.Response response = await _request();

    return json.decode(response.body);
  }

  int _getGridCount(List data) {
    if (_keywordController.text.isEmpty) {
      return data.length;
    }

    return data.length;
  }

  Widget _createGridLayout(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      itemCount: _getGridCount(snapshot.data['data']),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
      ),
      itemBuilder: (context, index) {
        if (_keywordController.text.isEmpty ||
            index < snapshot.data['data'].length - 1) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Container(
                  width: 10,
                  height: 10,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white10),
                    strokeWidth: 2,
                  ),
                ),
              ),
              GestureDetector(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data['data'][index]['images']['fixed_height']
                      ['url'],
                  height: 300,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data['data'][index]),
                    ),
                  );
                },
                onLongPress: () {
                  Share.share(snapshot.data['data'][index]['images']
                      ['downsized']['url']);
                },
              )
            ],
          );
        }

        return GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.refresh,
                color: Colors.white,
                size: 25,
              ),
              Text(
                'Load More',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _offset += _limit;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_keywordController.text.isNotEmpty) {
          print('KEYWOOOOOORD');
          setState(() {
            _keywordController.text = '';
            _offset = 0;
          });

          return Future.value(false);
        }

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.all(64),
            child: Image.network(
                'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _keywordController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                ),
                style: TextStyle(color: Colors.white, fontSize: 16),
                onSubmitted: (value) {
                  setState(() {
                    _keywordController.text = value;
                    _offset = 0;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _getGifList(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Container();
                        }

                        return _createGridLayout(context, snapshot);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
