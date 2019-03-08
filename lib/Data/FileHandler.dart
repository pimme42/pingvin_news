import 'package:pingvin_news/Misc/Log.dart';

import 'dart:async';
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

  Future<File> _file(String filename) async {
    final path = await _localPath;
    Log.doLog(("_file returning: ${path.path + filename}"), logLevel.DEBUG);
    return File(path.path + filename);
  }

  deleteFile(String filename) async {
    try {
      final file = await _file(filename);
      if (await file.exists()) file.delete();
    } catch (e) {
      Log.doLog(
          "Error Filehandler.deleteFile: ${e.toString()}", logLevel.ERROR);
    }
  }

  Future<String> getJsonFromFile(String filePath) async {
    try {
      Log.doLog("filehandler/getJsonFromFile path: $filePath", logLevel.DEBUG);
      final file = await _file(filePath);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      Log.doLog(
          "Error Filehandler.getJsonFromFile: ${e.toString()}", logLevel.ERROR);
      return null;
    }
  }

  Future<void> writeToFile(String filePath, String content) async {
    try {
      Log.doLog("filehandler/writeToFile path: $filePath", logLevel.DEBUG);
      final file = await _file(filePath);
      file.writeAsString(content, flush: true);
    } catch (e) {
      Log.doLog(
          "Error Filehandler.writeToFile: ${e.toString()}", logLevel.ERROR);
      return null;
    }
  }
}
