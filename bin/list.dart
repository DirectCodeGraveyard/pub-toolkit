#!/usr/bin/env dart
import "package:ansicolor/ansicolor.dart";
import "package:pub_toolkit/pub_toolkit.dart";
import "dart:io";

main() {
  var pen = new AnsiPen();

  var client = new PubClient(progress_tracker: (message) {
    print(message);
  });

  client.all_packages().then((list) {
    list.packages.forEach((package) {
      pen.white(bold: true);
      print(package.name);
    });
  }).catchError((error) {
    stderr.writeln(error);
    stderr.writeln(error.stackTrace);
  });
}
