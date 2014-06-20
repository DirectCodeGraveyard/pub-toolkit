#!/usr/bin/env dart
import "package:pub_toolkit/pub_toolkit.dart";

import "package:quiver/async.dart" show FutureGroup;

main() {
  var stats = new StatisticAnalyzer(new PubClient());
  var group = new FutureGroup();

  group.add(stats.package_count().then((count) {
    print("There are ${count} packages on pub");
  }));

  group.future.catchError((dynamic error) {
    print(error);
    print(error.stackTrace);
  });
}
