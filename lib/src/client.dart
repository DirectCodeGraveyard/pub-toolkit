part of pub.toolkit;

class PubClient {
  int cache_time = 120000;
  final String api_url;

  /* Caching Stuff */
  List<Package> _packages = null;
  DateTime _last_fetch = null;

  PubClient({this.api_url: "http://pub.dartlang.org/api"});

  Future<PackageList> all_packages() {
    if (_last_fetch != null && cache_time != -1) {
      /* If the Data is 2 minutes old or older, then we want to renew it, otherwise, return cached packages */
      if (_last_fetch.compareTo(new DateTime.now()) <= cache_time) {
        return new Future.value(_packages);
      }
    }

    var pkgs = [];

    var group = new FutureGroup();

    Future<int> page_count() {
      return PubCoreUtils.fetch_as_map("${api_url}/packages").then((response) {
        if (response == null) {
          throw new ServerException("Failed to Fetch Package Index");
        }
        return response["pages"];
      });
    }

    Future<Map<String, Object>> fetch_index(int page) {
      return PubCoreUtils.fetch_as_map("${api_url}/packages?page=${page}");
    }

    return page_count().then((pages) {
      for (int page = 1; !(page > pages); page++) {
        group.add(fetch_index(page));
      }
      return group.future;
    }).then((List<Map<String, Object>> pages) {
      pages.forEach((page) {
        pkgs.addAll(page["packages"]);
      });
      _last_fetch = new DateTime.now();
      _packages = pkgs;
      return new Future.value(new PackageList(pkgs, pub_url: api_url));
    });
  }
}
