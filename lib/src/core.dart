part of pub.toolkit;

class PubCoreUtils {
  static Future<Map<String, Object>> fetch_as_map(String url) {
    return http.get(url).then((response) {
      if (response.statusCode != 200) {
        return new Future.value(null);
      }
      return new Future.value(JSON.decoder.convert(response.body));
    });
  }

  static Future<Package> fetch_package(String api_url, String name) {
    return fetch_as_map("${api_url}/packages/${name}").then((map) {
      if (map == null) {
        return new Future.value(null);
      } else {
        return parse_package(map);
      }
    });
  }

  static Future<Package> parse_package(Map<String, Object> map) {
    Package package;

    return new Future(() {
      var name = map["name"];
      var uploaders = map["uploaders"];
      var versions = map["versions"];
      package = new Package(name);
      package.uploaders.addAll(uploaders);
      var group = new FutureGroup();
      for (Map<String, Object> version in versions) {
        group.add(parse_package_version(version));
      }
      return group.future;
    }).then((List<PackageVersion> versions) {
      package.versions.addAll(versions);
      package.latest_version_name = (map["latest"] as Map<String, Object>)["version"];
      return new Future.value(package);
    });
  }

  static Future<PackageVersion> parse_package_version(Map<String, dynamic> map) {
    return parse_pubspec(map["pubspec"]).then((pubspec) {
      var version = new PackageVersion(map["version"], map["url"]);
      version._pubspec = pubspec;
      return new Future.value(version);
    });
  }

  static Future<PubSpec> parse_pubspec(Map<String, Object> map) {
    return new Future(() {
      var spec = new PubSpec(map["name"], map["version"], map["description"]);
      spec.dependencies.addAll(map["dependencies"] != null ? map["dependencies"] : {});
      return new Future.value(spec);
    });
  }
}