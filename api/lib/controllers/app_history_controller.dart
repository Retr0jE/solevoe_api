 
import 'package:conduit/conduit.dart';
import 'package:conduittest/model/history.dart';

import '../utils/app_response.dart';

class AppHistoryController extends ResourceController {
  AppHistoryController(this.managedContext);

  final ManagedContext managedContext;
 @Operation.get()
  Future<Response> getHistory(
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
      final qGetAll = await Query<History>(managedContext)
       ..sortBy((x) => x.noteNameChange, order)
        ..offset = page
        ..fetchLimit = id;

      final notes = await qGetAll.fetch();

      var map2 = notes.map((e) {
        return {
          "id": e.id,
          "noteNameChange": e.noteNameChange,
          "operation": e.operation,
          "date": e.date
        
        };
      }).toList();
      return Response.ok( notes);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения истории');
    }
  }
}