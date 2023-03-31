import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduittest/model/history.dart';
import 'package:conduittest/model/zachetki.dart';

import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppZachetkiController extends ResourceController {
  AppZachetkiController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.put()
  Future<Response> updateNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() Zachetki note,
  ) async {
    try {

      final id = note.id;
      final fNote = await managedContext.fetchObjectWithID<Zachetki>(id);
      final qUpdateUser = Query<Zachetki>(managedContext)
        ..where((element) => element.id)
            .equalTo(id) 
        ..values.noteName = note.noteName ?? fNote!.noteName
        ..values.noteDateCreated =
            note.noteDateCreated ?? fNote!.noteDateCreated
        ..values.noteDateChanged =
            note.noteDateChanged ?? fNote!.noteDateChanged
        ..values.noteCategory = note.noteCategory ?? fNote!.noteCategory;
           await managedContext.transaction((transaction) async {
        final qHistoryAdd = Query<History>(transaction)
          ..values.noteNameChange = note.noteName
          ..values.date = DateTime.now()
          ..values.operation="The note was updated";
     

        await qHistoryAdd.insert();
    
      });
      await qUpdateUser.updateOne();
      final findUser = await managedContext.fetchObjectWithID<Zachetki>(id);
      findUser!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
        message: 'Успешное обновление данных',
        body: findUser.backing.contents,
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновление данных');
    }
  }

  @Operation.post()
  Future<Response> addNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() Zachetki note,
  ) async {
    try {

      int id = AppUtils.getIdFromHeader(header);

      await managedContext.transaction((transaction) async {
        final qCreateNote = Query<Zachetki>(transaction)
          ..values.noteName = note.noteName
          ..values.noteDateCreated = note.noteDateCreated
          ..values.noteDateChanged = note.noteDateChanged
          ..values.noteCategory = note.noteCategory
          ..values.active=1;

        final createdUser = await qCreateNote.insert();
        id = createdUser.id!;
      });
   await managedContext.transaction((transaction) async {
        final qHistoryAdd = Query<History>(transaction)
          ..values.noteNameChange = note.noteName
          ..values.date = DateTime.now()
          ..values.operation="The note was added";
     

        await qHistoryAdd.insert();
    
      });
      final findUser = await managedContext.fetchObjectWithID<Zachetki>(id);

      findUser!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
        message: 'Успешное добавление данных',
        body: findUser.backing.contents,
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка добавление данных');
    }
  }

  @Operation.delete()
  Future<Response> deleteNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() Zachetki note,
  ) async {
    try {
      final id = note.id;

      final fNote = await managedContext.fetchObjectWithID<Zachetki>(id);

      final qDeleteUser = Query<Zachetki>(managedContext)
        ..where((element) => element.id)
            .equalTo(id); 

   await managedContext.transaction((transaction) async {
        final qHistoryAdd = Query<History>(transaction)
          ..values.noteNameChange = note.noteName
          ..values.date = DateTime.now()
          ..values.operation="The note was deleted";
     

        await qHistoryAdd.insert();
    
      });
      await qDeleteUser.delete();

      return AppResponse.ok(
        message: 'Успешное удаление данных',
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка удаление данных');
    }
  }

  @Operation.get()
  Future<Response> getNote(
    @Bind.body() Zachetki note,
  ) async {
    try {
      final id = note.id;

      final user = await managedContext.fetchObjectWithID<Zachetki>(id);

      user!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
          message: 'Успешное получение заметки', body: user.backing.contents);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения заметки');
    }
  }
}
