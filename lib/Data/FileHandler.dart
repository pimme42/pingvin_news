import 'package:pingvin_news/Data/NewsEntry.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';
import 'package:pingvin_news/Misc/Log.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileHandler {
  static final FileHandler _singleton = new FileHandler._internal();

  factory FileHandler() {
    return _singleton;
  }

  FileHandler._internal();

  Future<Directory> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    //    print("Directory: " + directory.path);
    return directory;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
//    print(path);
    return File(path.path + "/news.json");
  }

  deleteFile() async {
    try {
      final file = await _localFile;
      if(await file.exists())
        file.delete();
    } catch (e) {
      Log.doLog(
          "Error Filehandler.deleteFile: ${e.toString()}", logLevel.ERROR);
    }
  }

  Future<File> writeNews(NewsPaper paper) async {
    //    print("Skriver " + pm.toString());
    //    print("Skriver till fil");
    final file = await _localFile;

    String tmp = json.encode(paper);
    file.writeAsString(tmp, flush: true);
    return file;
  }

  Future<NewsPaper> readNews() async {
    try {
      //      print("Läser in data");
//      await new Future.delayed(new Duration(seconds: 10));
//      Log.doLog("Times up in readNews", logLevel.DEBUG);
      final file = await _localFile;
      //      print("Fil: " + file.toString());

      // Read the file
      String contents = await file.readAsString();

      Map decode = jsonDecode(contents);
      NewsPaper paper = NewsPaper.fromJson(decode);

      return paper;
    } catch (e) {
      // If we encounter an error, return 0
      Log.doLog("Error Filehandler.readNews: ${e.toString()}", logLevel.ERROR);
      return null;
    }
  }
}
