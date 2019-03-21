import 'package:pingvin_news/flavor_config.dart';
import 'package:pingvin_news/main.dart';

import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.DEV,
    color: Colors.deepPurpleAccent,
    values: FlavorValues(),
  );
  runApp(MyApp());
}
