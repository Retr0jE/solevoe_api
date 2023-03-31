import 'package:conduit/conduit.dart';
import 'package:conduittest/api_app.dart' as conduittest;
import 'dart:io';

import 'package:conduittest/api_app.dart';

void main() async {
  final port = int.parse(Platform.environment["PORT"] ?? '8888');

  final service = Application<AppService>()..options.port = port;
  await service.start(numberOfInstances: 3, consoleLogging: true);
}
