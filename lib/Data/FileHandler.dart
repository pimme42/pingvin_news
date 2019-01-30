import 'package:pingvin_news/Data/NewsEntry.dart';
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

  Future<File> writeNews(List<NewsEntry> entries) async {
    //    print("Skriver " + pm.toString());
    //    print("Skriver till fil");
    final file = await _localFile;

    String tmp = json.encode(entries);
    file.writeAsString(tmp, flush: true);
    return file;
  }

  Future<List<NewsEntry>> readNews() async {
    try {
      //      print("Läser in data");
//      await new Future.delayed(new Duration(seconds: 1));
      final file = await _localFile;
      //      print("Fil: " + file.toString());

      // Read the file
      String contents = await file.readAsString();
      //      print("Contents: " + contents);
      List entries = json.decode(contents);
      //      print("Returning pm!" + pm.toString());
      return entries;
    } catch (e) {
      // If we encounter an error, return 0
      Log.doLog("Error Filehandler.readNews: ${e.toString()}", logLevel.ERROR);
      return null;
    }
  }
}
