import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _baseUrl = 'https://api.giphy.com/v1/gifs';
  String _key = 'xWcllBt57Hq8lJrAbw5fMafEn5RRNvj3';
  int _limit = 20;

  String _keyword;
  int _offset;

  Future<http.Response> _request() async {
    Uri requestTrending =
        Uri.parse("$_baseUrl/trending?api_key=$_key&limit=$_limit&rating=g");
    Uri requestSearch = Uri.parse(
        "$_baseUrl/search?api_key=$_key&q=$_keyword&limit=$_limit&offset=$_offset&rating=g&lang=en");

    if (_keyword != null) {
      return http.get(requestTrending);
    }

    return http.get(requestSearch);
  }

  Future<Map> _getGifList() async {
    http.Response response = await _request();

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifList().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              ),
              style: TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }

  Widget _createGridLayout(BuildContext context, AsyncSnapshot snapshot) {
    return Container();
  }
}
