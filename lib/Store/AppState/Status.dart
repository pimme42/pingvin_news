import 'package:pingvin_news/Redux/AppState/Actions.dart';

import 'dart:async';

class Status {
  final int loading;
  final StreamController<ShowSnackBarAction> snackBarItems;

  Status(this.loading, this.snackBarItems);

  factory Status.initial() => Status(
        0,
        StreamController.broadcast(),
      );
}
