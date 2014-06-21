#!/usr/bin/env dart
import "package:pub_toolkit/pub_toolkit.dart";

import "package:quiver/async.dart" show FutureGroup;

main() {
  var stats = new StatisticAnalyzer(new PubClient(progress_tracker: (message) {
    print(message);
  }));

  stats.initialize().then((_) {
    stats.package_count().then((count) {
      print("There are ${count} packages on pub");
    });

    stats.package_count().then((count) {
      print("There are ${count} packages on pub");
    });

    stats.total_versions().then((count) {
      print("There are ${count} published versions.");
    });

    stats.average_version_count().then((count) {
      print("The average version count is ${count}");
    });

    stats.largest_version_count().then((package) {
      print("The largest version count is ${package.versions.length} by ${package.name}");
    });
  });
}
