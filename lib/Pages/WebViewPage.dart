
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
  final flutterWebViewPlugin;

  _WebViewState(this._url) : this.flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: this._url,
      withZoom: true,
      withLocalStorage: false,
      primary: false,
      allowFileURLs: false,
      withJavascript: false,
      initialChild: Container(
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

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }


}

