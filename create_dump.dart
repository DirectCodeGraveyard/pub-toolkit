import "dart:io";
import "dart:convert";
import "dart:async";

var client = new HttpClient();
var packages = [];
int pages = 0;
int currentPage = 0;
bool verbose = false;
String outFile = "packages.json";

main(List<String> args) {
  if (args.length > 0) {
    outFile = args[0];
  }
  visit_url("http://pub.dartlang.org/api/packages");
}

visit_url(url) {
  client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
    return request.close();
  }).then((HttpClientResponse response) {
    response.transform(UTF8.decoder).transform(JSON.decoder).listen((content) {
      if (pages == 0) {
        pages = content["pages"];
      }
      currentPage++;
      var pkgs = content["packages"];
      packages.addAll(pkgs);
      if (currentPage != pages) {
        visit_url(content["next_url"]);
      } else {
        var encoder = new JsonEncoder.withIndent("    ");
        var file = new File(outFile);
        file.createSync(recursive: true);
        file.writeAsStringSync(encoder.convert(packages));
      }
    });
  });
}
