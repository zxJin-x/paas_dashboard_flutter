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
import 'package:paas_dashboard_flutter/api/mysql/mysql_databases_api.dart';
import 'package:paas_dashboard_flutter/module/mysql/mysql_sql_result.dart';
import 'package:paas_dashboard_flutter/persistent/po/mysql_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';

class MysqlSqlQueryViewModel extends BaseLoadListPageViewModel<Object> {
  MysqlInstancePo mysqlInstancePo;

  String dbname;

  List<String>? columns;

  MysqlSqlQueryViewModel(this.mysqlInstancePo, this.dbname) {
    columns = [''];
    this.fullList = [
      ['']
    ];
    this.displayList = this.fullList;
    loadSuccess();
    this.setDataConverter(this.getConvert);
  }

  String getDbname() {
    return this.dbname;
  }

  List<String> getColumns() {
    return this.columns == null ? [] : this.columns!;
  }

  Future<void> fetchSqlData(String sql) async {
    try {
      MysqlSqlResult result = await MysqlDatabaseApi.getSqlData(sql, mysqlInstancePo, dbname);
      this.columns = result.getFieldName;
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
    List<Object> v = obj;
    return new DataRow(cells: v.map((e) => DataCell(SelectableText(e.toString()))).toList());
  }

  MysqlSqlQueryViewModel deepCopy() {
    return new MysqlSqlQueryViewModel(mysqlInstancePo.deepCopy(), dbname);
  }
}
