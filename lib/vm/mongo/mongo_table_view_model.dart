//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/api/mongo/mongo_tables_api.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_database.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_sql_result.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_table.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';

class MongoTableViewModel extends BaseLoadListPageViewModel<Object> {
  final MongoInstancePo mongoInstancePo;
  final DatabaseResp databaseResp;
  final TableResp tableResp;
  List<String>? columns;

  MongoTableViewModel(this.mongoInstancePo, this.databaseResp, this.tableResp);

  MongoTableViewModel deepCopy() {
    return new MongoTableViewModel(mongoInstancePo.deepCopy(), databaseResp.deepCopy(), tableResp.deepCopy());
  }

  String get name {
    return mongoInstancePo.name;
  }

  String get databaseName {
    return databaseResp.databaseName;
  }

  String get tableName {
    return tableResp.tableName;
  }

  List<String> getColumns() {
    return this.columns == null ? [''] : this.columns!;
  }

  Future<void> fetchData() async {
    try {
      MongoSqlResult result = await MongoTablesApi.getTableData(mongoInstancePo.addr, mongoInstancePo.username,
          mongoInstancePo.password, databaseResp.databaseName, tableResp.tableName);
      this.columns = List.from(result.getFieldName);
      this.fullList = result.getData;
      this.displayList = this.fullList;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  DataRow getConvert(dynamic obj) {
    List<Object?> v = obj;
    return new DataRow(
        cells: v
            .map((e) => DataCell(e == null
                ? SelectableText("(N/A)", style: new TextStyle(color: Colors.grey))
                : SelectableText(e.toString())))
            .toList());
  }
}
