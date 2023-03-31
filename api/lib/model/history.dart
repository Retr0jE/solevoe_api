import 'package:conduit/conduit.dart';

class History extends ManagedObject<_History> implements _History {}

class _History {
  @primaryKey
  int? id;
  @Column(unique: false, indexed: true)
  String? noteNameChange;
    @Column(unique: false, indexed: true)
  String? operation;
  @Column(unique: false, indexed: true)
  DateTime? date;
  
}
