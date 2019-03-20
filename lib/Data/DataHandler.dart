class DataHandler {
  static int parseInt(dynamic value) {
    if (value == null) return null;
//    print("parseInt: ${value.toString()} : ${value.runtimeType}");
    dynamic retVal = value;
    if (value is String) {
      if (value.contains('.') || value.contains(','))
        retVal = double.parse(value).round();
      else
        retVal = int.parse(value);
    }
//    print("retVal: ${retVal.toString()} : ${retVal.runtimeType}");
    if (retVal is int) return retVal;
    throw FormatException("DataHandler.parseInt expects an int ($value)");
  }
}
