import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';

class Status {
  final int loading;
  final ShowSnackBarAction snackBar;

  Status(this.loading, this.snackBar);

  factory Status.initial() => Status(0, null);
}
