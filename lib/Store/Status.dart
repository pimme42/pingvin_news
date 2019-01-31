import 'package:pingvin_news/Misc/Constants.dart';

class Status {
  final List<int> openedNewsItems;
  final bool loading;

  Status(this.openedNewsItems, this.loading);

  factory Status.initial() => Status(List<int>(), false);

  bool newsItemSelected(int nid) =>
      (this.openedNewsItems.where((int item) => item == nid).length) > 0;
}
