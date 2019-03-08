import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';

import 'dart:async';

class Status {
  final int loading;
  final ShowSnackBarAction snackBar;
  final StreamController<ShowSnackBarAction> snackBarItems;

  Status(this.loading, this.snackBar, this.snackBarItems);

  factory Status.initial() => Status(
        0,
        null,
        StreamController.broadcast(),
      );
}
