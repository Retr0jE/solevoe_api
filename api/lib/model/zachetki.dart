import 'dart:ffi';

import 'package:conduit/conduit.dart';


class Zachetki extends ManagedObject<_Zachetki> implements _Zachetki {}

class _Zachetki {
  @primaryKey
  int? id;
  @Column(unique: true, indexed: true)
  String? noteName;
  @Column(unique: false, indexed: true)
  String? noteCategory;
  @Column(unique: false, indexed: true)
  String? noteDateCreated;
  @Column(unique: false, indexed: true)
  String? noteDateChanged;
  @Column(unique:false, indexed:true)
  int? active;
}
