import 'package:pingvin_news/Pages/Models/DrawerViewModel.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, DrawerViewModel>(
      onInit: (store) => store.dispatch(ReadSubscriptionsFromPrefsAction()),
      converter: (Store<AppStore> store) => DrawerViewModel.create(store),
      builder: (BuildContext context, DrawerViewModel viewModel) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: ExactAssetImage(viewModel.headerImage)),
                ),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        viewModel.headerTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]
              ..add(
                _createHeader(
                  context,
                  "Sidor",
                ),
              )
              ..addAll(
                viewModel.pages.map((DrawerPageViewModel page) =>
                    _createPageItemWidget(context, page)),
              )
              ..add(_createDivider(context))
              ..add(
                _createHeader(
                  context,
                  "Notifikationer",
                ),
              )
              ..addAll(viewModel.subItems.map((DrawerSubscribeItemView item) =>
                  _createSubscriptionWidget(context, item)))
              ..add(_createDivider(context))
              ..add(_createAboutCard(context, viewModel.aboutBoxViewModel))
              ..add(_createDivider(context)),
          ),
        );
      },
    );
  }

  Widget _createPageItemWidget(BuildContext context, DrawerPageViewModel page) {
    return Container(
      child: ListTile(
        leading: _createItemIcon(context, page.icon),
        onTap: () => page.tap(context),
        title: Text(
          page.text,
          style: page.style,
        ),
      ),
    );
  }

  Widget _createItemIcon(BuildContext context, dynamic icon) {
    Widget child;
    if (icon is String) {
      child = Text(
        icon,
        style: TextStyle(
          fontSize: IconTheme.of(context).size,
          fontWeight: FontWeight.bold,
          color: Colors.black45,
        ),
      );
    } else {
      child = icon;
    }
    return Container(
      width: IconTheme.of(context).size + 10,
//      decoration: BoxDecoration(border: Border.all()),
      child: Center(
        child: child,
      ),
    );
  }

  Widget _createSubscriptionWidget(
      BuildContext context, DrawerSubscribeItemView item) {
    return Container(
      child: SwitchListTile(
        value: item.subscribingTo,
        onChanged: (bool value) => item.subscribeTo(value),
        title: Text(
          item.subscribeText,
          style: item.style,
        ),
        secondary: _createItemIcon(context, Icon(item.subscribeIcons)),
        inactiveThumbImage: ExactAssetImage(item.thumbImage),
        inactiveTrackColor: Colors.black26,
        inactiveThumbColor: Colors.black12,
        activeThumbImage: ExactAssetImage(item.thumbImage),
        activeTrackColor: Colors.green[800],
        activeColor: Colors.white,
      ),
    );
  }

  Widget _createAboutCard(BuildContext context, DrawerPageViewModel viewModel) {
    return Container(
      child: ListTile(
        onTap: () => viewModel.tap(context),
        leading: _createItemIcon(
          context,
          Icon(
            viewModel.icon,
          ),
        ),
        title: Text(
          viewModel.text,
          style: viewModel.style,
        ),
      ),
    );
  }

  Widget _createHeader(BuildContext context, String text) => Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        ),
      );

  Widget _createDivider(BuildContext context) => Container(
        margin: EdgeInsets.only(
          bottom: 5.0,
          top: 5.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black26,
        ),
        child: Container(
          height: 1.5,
        ),
      );
}
