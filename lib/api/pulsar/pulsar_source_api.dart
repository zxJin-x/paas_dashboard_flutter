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

import 'dart:convert';
import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_source.dart';

class PulsarSourceApi {
  static Future<void> createSource(String host, int port, String tenant, String namespace, String sourceName,
      String outputTopic, String sourceType, String config) async {
    String url = 'http://$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace/$sourceName';
    SourceConfigReq sinkConfigReq =
        new SourceConfigReq(sourceName, tenant, namespace, outputTopic, json.decode(config), "builtin://$sourceType");
    String curlCommand = "curl '$url' -F sourceConfig='" + jsonEncode(sinkConfigReq) + ";type=application/json'";
    await FlutterClipboard.copy(curlCommand);
  }

  static Future<void> deleteSource(String host, int port, String tenant, String namespace, String sourceName) async {
    var url = 'http://$host:${port.toString()}/admin/v3/sources/$tenant/$namespace/$sourceName';
    final response = await http.delete(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<List<SourceResp>> getSourceList(String host, int port, String tenant, String namespace) async {
    var url = 'http://$host:${port.toString()}/admin/v3/sources/$tenant/$namespace';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((name) => new SourceResp(name)).toList();
  }

  static Future<SourceConfigResp> getSource(
      String host, int port, String tenant, String namespace, String sourceName) async {
    var url = 'http://$host:${port.toString()}/admin/v3/sources/$tenant/$namespace/$sourceName';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    Map jsonResponse = json.decode(response.body) as Map;
    return SourceConfigResp.fromJson(jsonResponse);
  }
}
