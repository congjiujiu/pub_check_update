import 'package:dio/dio.dart';

Future<Map<String, String>> fetchAll(Map<String, String> pkgs) async {
  final futures = <Future<Map<String, String>>>[];

  for (final key in pkgs.keys) {
    futures.add(fetchOne(key));
  }

  final versions = await Future.wait(futures);
  final latestVersionMap = mergeMap(versions);

  return latestVersionMap;
}

Future<Map<String, String>> fetchOne(String name) async {
  final data = await fetchFromPub(name);

  final latestVersion = getLatestVersion(data);

  return { name: latestVersion };
}

Future<Map<String, dynamic>> fetchFromPub(String name) async {
  const baseUrl = 'https://pub.flutter-io.cn/api/packages/';
  final headers = {
    'accept': 'application/vnd.pub.v2+json',
  };

  try {
    final Response response = await Dio().get('$baseUrl$name', options: Options(headers: headers));
    final body = Map<String, dynamic>.from(response.data);

    return body;
  } catch(e) {
    throw e;
  }
}

String getLatestVersion(Map<String, dynamic> data) {
  final latest = Map<String, dynamic>.from(data['latest'] ?? {});
  final version = (latest['version'] ?? '').toString();

  return version;
}

Map<String, String> mergeMap(List<Map<String, String>> map) {
  final Map<String, String> res = {};
  map.forEach((m) => res.addAll(m));
  return res;
}