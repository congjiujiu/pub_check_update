import 'package:pub_semver/pub_semver.dart';

final wildCardPrefixExp = RegExp(r'^\^');

int compareVersions(String a, String b) {
  final versionA = Version.parse(a);
  final versionB = Version.parse(b);

  return versionA.compareTo(versionB);
  // return Version.prioritize(versionA, versionB);
}

bool hasWildCard(String version) {
  return wildCardPrefixExp.hasMatch(version);
}

String getVersionPart(String version) {
  if (version == null) {
    return null;
  }

  if (hasWildCard(version)) {
    return version.replaceAll(wildCardPrefixExp, '');
  }

  return version;
}
