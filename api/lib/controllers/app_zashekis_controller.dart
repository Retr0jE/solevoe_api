import 'dart:developer';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduittest/model/zachetki.dart';

import '../model/history.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppZashekisController extends ResourceController {
  AppZashekisController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getNotes(
    @Bind.query('page') int page,
    @Bind.query('amount') int amount,
        @Bind.query('filter') String filter
  ) async {
    try {
         QuerySortOrder order=QuerySortOrder.descending;
      if(filter=="true")
      {
        order=QuerySortOrder.ascending;
      }
      else{
        order=QuerySortOrder.descending;
      }
      final id = amount;
      final qGetAll = await Query<Zachetki>(managedContext)
         ..sortBy((x) => x.noteName, order)
        ..offset = page
        ..fetchLimit = id;

      final notes = await qGetAll.fetch();

      var map2 = notes.map((e) {
        if(e.active==1)
        return {
          "id": e.id,
          "noteName": e.noteName,
          "noteCategory": e.noteCategory,
          "noteDateCreated": e.noteDateCreated,
          "noteDateChanged": e.noteDateChanged,
          "active":e.active
        };
      }).toList();
      return AppResponse.ok(message: 'Успешное получение заметки', body: map2);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения заметки');
    }
  }
   @Operation.put()
  Future<Response> setActiveNote(
    @Bind.query('active') int active,
    @Bind.query('id') int id,

  
  ) async {
      try{
      final fNote = await managedContext.fetchObjectWithID<Zachetki>(id);
   
      final qUpdateUser = Query<Zachetki>(managedContext)
     
        ..where((element) => element.id)
            .equalTo(id) 
       ..values.active=active;
        final user = await managedContext.fetchObjectWithID<Zachetki>(id);
           await managedContext.transaction((transaction) async {
        final qHistoryAdd = Query<History>(transaction)
          ..values.noteNameChange = user?.noteName
          ..values.date = DateTime.now()
          ..values.operation="The note was updated";
     

        await qHistoryAdd.insert();
    
      });
      await qUpdateUser.updateOne();
      final findUser = await managedContext.fetchObjectWithID<Zachetki>(id);
      findUser!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
        message: 'Запись скрыта',
        body: findUser.backing.contents,
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновление данных');
    }
  }
}
