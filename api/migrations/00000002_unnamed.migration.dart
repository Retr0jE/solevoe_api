import 'dart:async';
import 'package:conduit_core/conduit_core.dart';   

class Migration2 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_History", "noteNameChange", (c) {c.isUnique = false;});
		database.alterColumn("_History", "operation", (c) {c.isUnique = false;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    