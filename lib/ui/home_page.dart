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
    return Container();
  }
}
