class VersionInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  VersionInfo({this.appName, this.packageName, this.version, this.buildNumber});

  factory VersionInfo.initial() => VersionInfo(
        appName: "",
        buildNumber: "",
        packageName: "",
        version: "",
      );
}
