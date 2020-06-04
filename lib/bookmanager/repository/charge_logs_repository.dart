import 'dart:async';

import 'package:ownspace/bookmanager/model/charge_log.dart';
import 'package:ownspace/common/database/database_provider.dart';

class ChargeLogsRepository {

  Future<List<ChargeLog>> fetchChargeLogs() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor =
      await db.query(DatabaseProvider.BOOKS_CHARE_LOG_TABLE);
    db.close();
    return cursor.map((row) => ChargeLog.fromEntity(row)).toList();
  }

  Future addChargeLog(ChargeLog chargeLog) async {
    var db = await DatabaseProvider().open();
    await db.insert(DatabaseProvider.BOOKS_CHARE_LOG_TABLE, chargeLog.toMap());
    db.close();
  }

  Future deleteChargeLog(ChargeLog chargeLog) async {
    var db = await DatabaseProvider().open();
    await db.delete(
        DatabaseProvider.BOOKS_CHARE_LOG_TABLE,
        where: "_id = ?",
        whereArgs: [chargeLog.id]);
    db.close();
  }

}