part of pub.pkgs;

File current_packages_file() {
  return new File("data/packages.json");
}

DateTime parseTime(String input) {
  return new DateTime.parse(input);
}

List<Map<String, Object>> current_packages() {
  return JSON.decoder.convert(current_packages_file().readAsStringSync()) as List<Map<String, Object>>;
}