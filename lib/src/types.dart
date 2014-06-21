part of pub.toolkit;

class Package {
  final String name;
  final Set<String> uploaders;
  final Set<PackageVersion> versions;
  String latest_version_name;

  PackageVersion get latest_version => versions.where((version) => version.version == latest_version_name).first;

  Package(this.name) :
    uploaders = new Set<String>(),
    versions = new Set<PackageVersion>();

  @override
  toString() => "Package(name: ${name}, uploaders: ${uploaders}, versions: ${versions})";
}

class PackageVersion {
  final String url;
  final String version;
  PubSpec _pubspec;
  PubSpec get pubspec => _pubspec;

  PackageVersion(this.version, this.url);

  @override
  toString() => "PackageVersion(version: ${version}, url: ${url}, pubspec: ${pubspec})";
}

class PubSpec {
  final String name;
  final String version;
  String description;
  final Map<String, String> dependencies;

  PubSpec(this.name, this.version, this.description) : dependencies = {};

  @override
  toString() => "PubSpec(name: ${name}, version: ${version}, description: ${description}, dependencies: ${dependencies})";
}

class PackageList {
  final List<Package> packages;
  final String pub_url;

  PackageList(this.packages, {this.pub_url: "http://unspecified"});

  bool has_package(String name) => packages.any((pkg) => pkg.name == name);

  Package package_by_name(String name) {
    for (Package package in packages) {
      if (package.name == name) {
        return package;
      }
    }
    return null;
  }

  bool package_has_version(String name, String version) {
    package_by_name(name) != null && package_by_name(name).versions.any((version) => version.version == version);
  }

  int get length => packages.length;
}

typedef ProgressTracker(String message);