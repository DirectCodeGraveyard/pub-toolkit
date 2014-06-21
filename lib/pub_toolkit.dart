library pub.toolkit;

import "dart:io";
import "dart:convert";
import "dart:async";
import "package:http/http.dart" as HTTP;
import "package:quiver/async.dart";
import "dart:math" as Math;
import "dart:isolate";

part 'src/core.dart';
part 'src/client.dart';
part 'src/statistics.dart';
part 'src/types.dart';
part 'src/exception.dart';

HTTP.Client _http = null;

HTTP.Client get http {
  if (_http == null) {
    var client = new HttpClient();
    client.idleTimeout = new Duration(seconds: 10);
    client.maxConnectionsPerHost = 4;
    client.userAgent = "Pub Toolkit on Dart v${Platform.version}";
    _http = new HTTP.IOClient(client);
  }
  return _http;
}