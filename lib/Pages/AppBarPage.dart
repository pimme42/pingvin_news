import 'package:pingvin_news/Pages/Models/AppBarViewModel.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Pages/LoadIndicator.dart';

import 'package:pingvin_news/Store/AppState/AppStore.dart';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AppBarPage extends StatefulWidget implements PreferredSizeWidget {
  AppBarPage({Key key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AppBarPageState createState() => _AppBarPageState();
}

class _AppBarPageState extends State<AppBarPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, AppBarViewModel>(
        converter: (Store<AppStore> store) => AppBarViewModel.create(store),
        builder: (BuildContext context, AppBarViewModel viewModel) {
          return AppBar(
            title: new Text(viewModel.title),
            automaticallyImplyLeading: true,
            leading: _displayLeading(context, viewModel),
            actions: _displayAppBarActions(context, viewModel),
          );
        });
  }

  Widget _displayLeading(BuildContext context, AppBarViewModel viewModel) {
    if (viewModel.showWebView)
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () => viewModel.closeWebView(),
      );
    if (viewModel.showPopButton)
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => viewModel.pop(),
      );
    return null;
  }

  List<Widget> _displayAppBarActions(
      BuildContext context, AppBarViewModel viewModel) {
    return <Widget>[
      Padding(
        child: viewModel.loading
            ? LoadIndicator()
            : Transform(
                origin: Offset(IconTheme.of(context).size / 2,
                    IconTheme.of(context).size / 2),
                transform: Matrix4.skewX(-0.0),
                child: ImageIcon(
                  ExactAssetImage(Constants.logoPathEllipse),
                ),
              ),
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      ),
    ];
  }
}
