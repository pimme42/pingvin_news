import 'package:pingvin_news/Misc/Constants.dart';

import 'package:pingvin_news/Redux/Actions.dart';

import 'package:pingvin_news/Store/NewsStore.dart';

import 'package:pingvin_news/Data/NewsEntry.dart';

import 'package:pingvin_news/Pages/WebViewPage.dart';
import 'package:pingvin_news/Pages/LoadWidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'dart:async';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(Constants.title),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          Constants.logoAction,
        ],
      ),
      body: StoreConnector<NewsStore, _ViewModel>(
          onInit: (store) => store.dispatch(ReadNewsAction()),
          converter: (Store<NewsStore> store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) {
            if(viewModel.items.length == 0) {
              return LoadWidget();
            }
            return new IconTheme(
              data: new IconThemeData(color: Theme.of(context).accentColor),
              child: ListView(
                  padding: EdgeInsets.all(5.0),
                  children: viewModel.items
                      .map((_NewsItemViewModel item) =>
                          _createListItemWidget(item, context))
                      .toList()),
            );
          }),
    );
  }

  Widget _createListItemWidget(_NewsItemViewModel item, BuildContext context) =>
      Card(
        child: ExpansionTile(
          leading: IconButton(
            icon: item.leadingIcon,
            onPressed: () => item.onPressed(context),
          ),
          title: Text(item.title),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(item.summary),
            ),
          ],
        ),
      );
}

class _ViewModel {
  final List<_NewsItemViewModel> items;

  _ViewModel(this.items);

  factory _ViewModel.create(Store<NewsStore> store) {
    List<_NewsItemViewModel> items = store.state.paper.entries
        .map(
          (NewsEntry item) => _NewsItemViewModel(
                Icon(Icons.link),
                (BuildContext context) {
                  print("Building");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(item.link),
                    ),
                  );
                },
                item.title,
                item.summary,
              ),
        )
        .toList();
    return _ViewModel(
      items,
    );
  }
}

@immutable
class _NewsItemViewModel {
  final Widget leadingIcon;
  final Function(BuildContext) onPressed;
  final String title;
  final String summary;

  _NewsItemViewModel(
      this.leadingIcon, this.onPressed, this.title, this.summary);
}

/*

import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';
import 'package:pingvin_news/Pages/WebViewPage.dart';
import 'package:pingvin_news/Data/FileHandler.dart';

import 'package:flutter/material.dart';
import 'dart:convert';


class NewsPage extends StatefulWidget {
  NewsPage();

  @override
  _NewsPageState createState() => new _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsEntry> _entries;
  FileHandler fh = new FileHandler();

  _NewsPageState() {
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Constants.title),
        actions: <Widget>[
          Constants.logoAction,
        ],
//        leading:
      ),
      body: ListView.builder(
        itemCount: this._entries.length,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
              leading: IconButton(
                icon: Icon(Icons.link),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewPage(this._entries[index].link),
                    ),
                  );
                },
              ),
              initiallyExpanded: index == 0 ? true : false,
              title: Text(this._entries[index].title),
              children: <Widget>[
                Text(this._entries[index].summary),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/
