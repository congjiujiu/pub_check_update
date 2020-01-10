import 'package:pub_check_updates/utils.dart';
import 'package:pub_check_updates/version_util.dart';

void analysisVersions(Map<String, String> local, Map<String, String> latest) {
  final List<VersionCompare> res = [];

  for (final key in local.keys) {
    final localVersion = getVersionPart(local[key]);
    final latestVersion = getVersionPart(latest[key]);

    if (latestVersion != null) {
      final newest = checkHasUpdates(localVersion, latestVersion);

      res.add(VersionCompare(key, localVersion, latestVersion, hasUpdate: newest));
    }
  }

  printUpdates(res);
}

bool checkHasUpdates(String ver1, String ver2) {
  final compare = compareVersions(ver1, ver2);

  if (compare < 0) {
    return true;
  }

  return false;
}

void printUpdates(List<VersionCompare> pkgs) {
  pkgs.forEach((pkg) {
    if (!pkg.hasUpdate) {
      return;
    }

    printUpdate(pkg);
  });
}

void printUpdate(VersionCompare pkg) {
  print('${pkg.name}     ${pkg.currentVersion}    ->    ${pkg.lastestVersion}');
}
