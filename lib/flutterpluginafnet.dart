import 'dart:async';

import 'package:flutter/services.dart';

class Flutterpluginafnet {
  static const MethodChannel _channel =
      const MethodChannel('flutterpluginafnet');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map> startGetRequest(String url, {Map param}) async {
    Map arguments = {"url": url, "param": param ?? {}};
    final Map jsonData = await _channel.invokeMethod('getRequest', arguments);
    print("在flutter获取到的jsonData=$jsonData");
    return jsonData;
  }
}
