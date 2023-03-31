// int calculate() {
//   return 1000 - 7;
// }

import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduittest/controllers/app_history_controller.dart';
import 'package:conduittest/controllers/app_zachetki_controller.dart';
import 'package:conduittest/controllers/app_zashekis_controller.dart';
import 'package:conduittest/controllers/app_token_contoller.dart';
import 'package:conduittest/controllers/app_user_contoller.dart';

import 'controllers/app_auth_controller.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;
  @override
  Future prepare() {
    final persistentStore = _initDatabase();
    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
    ..route('token/[:refresh]').link(() => AppAuthController(managedContext))
    ..route('note')
        .link(AppTokenContoller.new)!
        .link(() => AppZachetkiController(managedContext))
    ..route('notes')
        .link(AppTokenContoller.new)!
        .link(() => AppZashekisController(managedContext))
    ..route('user')
        .link(AppTokenContoller.new)!
        .link(() => AppUserController(managedContext))
    ..route('history')
        .link(AppTokenContoller.new)!
        .link(() => AppHistoryController(managedContext));

  PersistentStore _initDatabase() {
    final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? '111';
    final host = Platform.environment['DB_HOST'] ?? '127.0.0.1';
    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
    final databaseName = Platform.environment['DB_NAME'] ?? 'postgres';
    return PostgreSQLPersistentStore(
        username, password, host, port, databaseName);
  }
}
