part of pub.toolkit;

class PubToolkitException extends Exception {
  final String message;
  Exception _cause;
  Exception get cause;

  PubToolkitException(this.message, [this.cause]);

  @override
  toString() => message;
}

class PackageNotFoundException extends PubToolkitException {
  PackageNotFoundException(String packageName) : super(_generate_message(packageName));

  static String _generate_message(String packageName) => "the specified package '${packageName}' does not exist";
}

class VersionNotFoundException extends PubToolkitException {
  VersionNotFoundException(String name, String version) : super(_generate_message(name, version));

  static String _generate_message(String name, String version) => "the specified package version '${version}' for '${version}' does not exist";
}

class ServerException extends PubToolkitException {
  ServerException(String message) : super(message);
}