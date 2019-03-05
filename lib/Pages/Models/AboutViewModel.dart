import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';

import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

class AboutViewModel {
  final Map<String, String> packageInfo;
  final String aboutText;
  final String contactText;
  final String contactEmail;
  final Function() contactOnTap;
  final String legalese;
  final Function() pop;

  AboutViewModel(
    this.packageInfo,
    this.aboutText,
    this.contactText,
    this.contactEmail,
    this.contactOnTap,
    this.legalese,
    this.pop,
  );
//      {this.appName, this.packageName, this.version, this.buildNumber});

  factory AboutViewModel.create(Store<AppStore> store) => AboutViewModel(
        {
          'appName': store.state.versionInfo.appName,
          'buildNumber': store.state.versionInfo.buildNumber,
          'packageName': store.state.versionInfo.packageName,
          'version': store.state.versionInfo.version,
        },
        "Den här appen är skapad av Tobias Rörstam",
        "Kontakt: ",
        "pingvin_app@pimme.org",
        () => _launchUrl(
            'mailto:"pingvin_app@pimme.org"?subject=Appen Pingvin Rugby Club'),
        "Den här appen används på eget bevåg",
        () => store.dispatch(NavigateToAction.pop()),
      );

  static void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
