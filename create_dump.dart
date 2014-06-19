import "dart:io";
import "dart:convert";
import "dart:async";

var client = new HttpClient();
var packages = [];
int pages = 0;
int currentPage = 0;
String outFile = "packages.json";

main(List<String> args) {
  if (args.length > 0) {
    outFile = args[0];
  } else {
    var now = new DateTime.now();
    var month = get_month(now);
    outFile = "${now.year}/${month}/${now.day}/packages.json";
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
        var current = new File("current/packages.json");
        current.createSync(recursive: true);
        current.writeAsStringSync(encoder.convert(packages));
      }
    });
  });
}

get_month(DateTime now) {
  switch (now.month) {
    case DateTime.JANUARY:
      return "January";
    case DateTime.FEBRUARY:
      return "February";
    case DateTime.MARCH:
      return "March";
    case DateTime.APRIL:
      return "April";
    case DateTime.MAY:
      return "May";
    case DateTime.JUNE:
      return "June";
    case DateTime.JULY:
      return "July";
    case DateTime.AUGUST:
      return "August";
    case DateTime.SEPTEMBER:
      return "September";
    case DateTime.OCTOBER:
      return "October";
    case DateTime.NOVEMBER:
      return "November";
    case DateTime.DECEMBER:
      return "Decemeber";
    default:
      print("LOLNO");
  }
}