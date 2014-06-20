part of pub.pkgs;

var client = new HttpClient();
var packages = [];
int pages = 0;
int currentPage = 0;
String outDir = "data";
var encoder = new JsonEncoder();

create_dump() {
  var dir = new Directory(outDir);
  
  if (dir.existsSync()) {
    print("Removing Old Data");
    dir.deleteSync(recursive: true);
  }

  print("Fetching Package Index");
  visit_packages_url("http://pub.dartlang.org/api/packages");
}

visit_packages_url(url) {
  return http.get(url).then((response) {
    var content = JSON.decoder.convert(response.body);

    if (pages == 0) {
        pages = content["pages"];
    }
    currentPage++;
    var pkgs = content["packages"];
    packages.addAll(pkgs);

    if (currentPage != pages) {
      visit_packages_url(content["next_url"]);
    } else {
      var file = new File("${outDir}/packages.json");
      file.create(recursive: true).then((_) {
        return file.writeAsString(encoder.convert(packages));
      }).then((_) {
        for (var pkg in packages) {
          visit_package_url(pkg);
        }
      });
    }
  });
}

visit_package_url(pkg) {
  http.get(pkg['url']).then((response) {
    print("Creating Package Information for '${pkg['name']}'");
    var content = JSON.decoder.convert(response.body);
    var file = new File("${outDir}/package/${content['name']}.json");
    file.create(recursive: true).then((_) {
      return file.writeAsString(encoder.convert(packages));
    }).then((_) {
      for (var version in content['versions']) {
        visit_package_version_url(version, content['name']);
      }
    });
  });
}

visit_package_version_url(pkg, name) {
  http.get(pkg['url']).then((response) {
    print("Creating Version Information for '${pkg['pubspec']['name']}@${pkg['version']}'");
    var content = JSON.decoder.convert(response.body);
    var file = new File("${outDir}/package/${name}/${content['version']}.json");
    
    file.create(recursive: true).then((_) {
      return file.writeAsString(encoder.convet(package));
    });
  });
}