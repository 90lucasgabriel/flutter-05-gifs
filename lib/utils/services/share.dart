import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:share/share.dart';

void share(String source) async {
  Uri url = Uri.parse(source);

  var response = await http.get(url);
  final documentDirectory = (await getApplicationDocumentsDirectory()).path;

  File imgFile = new File('$documentDirectory/flutter.gif');
  imgFile.writeAsBytesSync(response.bodyBytes);

  Share.shareFiles(['$documentDirectory/flutter.gif']);
}
