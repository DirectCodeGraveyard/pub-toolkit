part of pub.toolkit;

class StatisticAnalyzer {
  final PubClient client;

  StatisticAnalyzer(this.client);

  Future<int> package_count() {
    return client.all_packages().then((packages) {
      return new Future.value(packages.size());
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
    return client.all_packages().then((packages) {
      if (packages.has_package(name))
        throw new PackageNotFoundException(name);
      if (packages.package_has_version(name, version))
        throw new VersionNotFoundException(name, version);
      return new Future.value(packages.where((pkg) {
        return pkg.latest_version.pubspec.dependencies[name] == version;
      }));
    });
  }
}