class DataHandler {
  static int parseInt(dynamic value) {
//    print("_toInt: ${value.toString()} : ${value.runtimeType}");
    if (value is String) {
      if (value.contains('.') || value.contains(','))
        value = double.parse(value).round();
      else
        value = int.parse(value);
    }
    if (value is int) return value;
    throw FormatException("_ToInt expects an int");
  }
}
