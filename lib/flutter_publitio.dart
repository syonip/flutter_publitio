import 'dart:async';
import 'package:flutter/services.dart';

class FlutterPublitio {
  static const MethodChannel _channel = const MethodChannel('flutter_publitio');

  static Future<void> configure(String apiKey, String apiSecret) async {
    await _channel.invokeMethod('configure', {
      "apiKey": apiKey,
      "apiSecret": apiSecret,
    });
  }

  static Future<dynamic> uploadFile(String path, options) async {
    final result = await _channel
        .invokeMethod('uploadFile', {"path": path, "options": options});
    return result;
  }
}
