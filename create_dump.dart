import "dart:io";
import "dart:convert";
import "dart:async";

var client = new HttpClient();
var packages = [];
int pages = 0;
int currentPage = 0;
bool verbose = false;

main(List<String> argz) {
  var args = new List.from(argz);
  verbose = args.contains("--verbose");
  visit_url("http://pub.dartlang.org/api/packages");
}

visit_url(url) {
  if (verbose)
    print("Visiting URL: ${url}");
  client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
    return request.close();
  }).then((HttpClientResponse response) {
    response.transform(UTF8.decoder).transform(JSON.decoder).listen((content) {
      if (pages == 0) {
        pages = content["pages"];
      }
      currentPage++;
      var pkgs = content["packages"];
      if (verbose)
        print("Found ${pkgs.length} Packages");
      packages.addAll(pkgs);
      if (currentPage != pages) {
        visit_url(content["next_url"]);
      } else {
        var encoder = new JsonEncoder("    ");
        var file = new File("pub-packages.json");
        file.createSync();
        file.writeAsStringSync(encoder.convert(packages));
      }
    });
  });
}
