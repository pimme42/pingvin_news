import 'package:pingvin_news/Misc/Constants.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';

class WebViewPage extends StatefulWidget {
  final String _url;
  WebViewPage(this._url);

  @override
  _WebViewState createState() => new _WebViewState(this._url);
}

class _WebViewState extends State<WebViewPage> {
  final String _url;
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  _WebViewState(this._url);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: this._url,
      appBar: AppBar(
        title: Text(Constants.title),
        actions: <Widget>[
          Constants.logoAction,
        ],
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
//        color: Colors.redAccent,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                flutterWebViewPlugin.goBack();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                flutterWebViewPlugin.goForward();
              },
            ),
            IconButton(
              icon: const Icon(Icons.autorenew),
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
          ],
        ),
      ),
    );
  }
}

