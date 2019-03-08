import 'package:pingvin_news/Store/AppState/AppStore.dart';

import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutViewModel {
  final Map<String, String> packageInfo;
  final String aboutTitle;
  final String aboutText;
  final String contactText;
  final String contactEmail;
  final Function() contactOnTap;
  final String legalese;

  AboutViewModel(
    this.packageInfo,
    this.aboutTitle,
    this.aboutText,
    this.contactText,
    this.contactEmail,
    this.contactOnTap,
    this.legalese,
  );
//      {this.appName, this.packageName, this.version, this.buildNumber});

  factory AboutViewModel.create(Store<AppStore> store) => AboutViewModel(
        {
          'appName': store.state.versionInfo.appName,
          'buildNumber': store.state.versionInfo.buildNumber,
          'packageName': store.state.versionInfo.packageName,
          'version': store.state.versionInfo.version,
        },
        "Om appen",
        "Den här appen är skapad av Tobias Rörstam, appen är ingen officiell Pingvin "
            "app utan är skapad för att jag vill lära mig hur man bygger appar.",
        "Kontakt: ",
        "pingvin_app@pimme.org",
        () => _launchUrl(
            'mailto:"pingvin_app@pimme.org"?subject=Appen Pingvin Rugby Club'),
        "Den här appen används på eget bevåg",
      );

  static void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
