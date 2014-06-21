part of pub.toolkit;

class PubClient {
  int cache_time = 120000;
  final String api_url;

  /* Caching Stuff */
  List<Package> _packages = null;
  DateTime _last_fetch = null;
  final ProgressTracker tracker;

  PubClient({this.api_url: "http://pub.dartlang.org/api", progress_tracker: null}) :
    tracker = progress_tracker == null ? ((message) {}) : progress_tracker;

  Future<PackageList> all_packages() {
    if (_last_fetch != null && cache_time != -1) {
      /* If the Data is 2 minutes old or older, then we want to renew it, otherwise, return cached packages */
      if (_last_fetch.compareTo(new DateTime.now()) <= cache_time) {
        tracker("cache:used=true:stamp:${_last_fetch}");
        return new Future.value(_packages);
      }
    }

    tracker("cache:used=false");

    var group = new FutureGroup();

    Future<int> page_count() {
      return PubCoreUtils.fetch_as_map("${api_url}/packages").then((response) {
        tracker("fetched:type=page_count:url=${api_url}/packages");
        if (response == null) {
          throw new ServerException("Failed to Fetch Package Index");
        }
        return response["pages"];
      });
    }

    Future<Map<String, Object>> fetch_index(int page) {
      return PubCoreUtils.fetch_as_map("${api_url}/packages?page=${page}").then((val) {
        tracker("fetched:type=page:number=${page}:url=${api_url}/packages?page=${page}");
        return new Future.value(val);
      });
    }

    return page_count().then((pages) {
      for (int page = 1; !(page > pages); page++) {
        group.add(fetch_index(page));
      }
      return group.future;
    }).then((List<Map<String, Object>> pages) {
      var waits = new FutureGroup();
      pages.forEach((page) {
        for (Map<String, Object> info in page["packages"]) {
          waits.add(PubCoreUtils.fetch_package(api_url, info["name"]).then((package) {
            if (package == null) {
              throw new ServerException("failed to fetch package '${info["name"]}'");
            }
            tracker("fetched:type=package:name=${package.name}:url=${api_url}/packages/${package.name}");
            tracker("progress:waiting_for=${waits.results.where((i) => i == null).length}:complete=${waits.results.where((i) => i != null).length}");
            return new Future.value(package);
          }));
        }
      });
      return waits.future;
    }).then((List<Package> packages) {
      _last_fetch = new DateTime.now();
      _packages = packages;
      return new Future.value(new PackageList(packages, pub_url: api_url));
    });
  }
}
