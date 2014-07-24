part of pub.toolkit;

class StatisticAnalyzer {
  final PubClient client;

  StatisticAnalyzer(this.client);

  Future initialize() {
    return client.all_packages();
  }

  Future<int> package_count() {
    return client.all_packages().then((PackageList packages) {
      return new Future.value(packages.length);
    });
  }

  Future<int> total_versions() {
    return client.all_packages().then((list) {
      var count = 0;
      list.packages.forEach((pkg) {
        count += pkg.versions.length;
      });
      return new Future.value(count);
    });
  }

  Future<int> packages_depending_on(String name, [String version = "latest"]) {
    return client.all_packages().then((PackageList list) {
      if (list.has_package(name))
        throw new PackageNotFoundException(name);
      if (list.package_has_version(name, version))
        throw new VersionNotFoundException(name, version);
      return new Future.value(list.packages.where((pkg) {
        return pkg.latest_version.pubspec.dependencies[name] == version;
      }));
    });
  }

  Future<int> average_version_count() {
    return client.all_packages().then((list) {
      var numbers = [];
      list.packages.forEach((pkg) {
        numbers.add(pkg.versions.length);
      });
      var together = 0;
      numbers.forEach((number) => together += number);
      return new Future.value(together / numbers.length);
    });
  }

  Future<Package> largest_version_count() {
    return client.all_packages().then((list) {
      var pkgs = new List<Package>.from(list.packages);
      pkgs.sort((Package a, Package b) => a.versions.length.compareTo(b.versions.length));
      return new Future.value(pkgs.last);
    });
  }

  Future<Package> random_package() {
    return client.all_packages().then((list) {
      var pkgs = new List<Package>.from(list.packages);
      pkgs.shuffle();
      return new Future.value(pkgs.first);
    });
  }

  Future<Package> oldest_package() {
    
  }
}