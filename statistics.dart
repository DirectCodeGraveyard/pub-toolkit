import "core.dart";

var packages;

load() => packages = current_packages();

main() {
  if (args.length == 0) {

  }

}

global_stats() {
  load();
  print("There are ${packages.length} packages");
  packages.sort((a, b) {
    var vA = a["latest_version"];
  });
}