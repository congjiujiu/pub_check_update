import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:yaml/yaml.dart';

import 'package:pub_check_updates/analysis.dart';
import 'package:pub_check_updates/version_manager.dart';

void run() async {
  print('running');

  final pkgs = await findPackage();

  final lastestVersions = await fetchAll(pkgs);

  analysisVersions(pkgs, lastestVersions);
}

Future<Map<String, String>> findPackage() async {
  print('finding packages');

  final pkgFileName = getPackageFileName();

  // get file from package name
  final pkgFile = await getPackageFile(pkgFileName);

  if (pkgFile == null) {
    return null;
  }

  // read file content
  final content = await readFile(pkgFile);

  // tranlates yaml file to json
  final contentJson = transYaml(content);

  return formatPackages(contentJson);
}

String getPackageFileName() {
  return 'pubspec.yaml';
}

Future<File> getPackageFile(String path) async {
  final file = File(path);
  final fileExisted = await file.exists();

  if (!fileExisted) {
    print('No pubspec.yaml found in this dir');
    return null;
  }

  return file;
}

Future<String> readFile(File file) async {
  final content = await file.readAsString();
  return content;
}

Map<String, dynamic> transYaml(String yaml) {
  final doc = loadYaml(yaml);
  final data = json.decode(json.encode(doc));

  return data;
}

Map<String, String> formatPackages(Map<String, dynamic> json) {
  final dependencies = Map<String, dynamic>.from(json['dependencies'] ?? {});
  final devDependencies = Map<String, dynamic>.from(json['dev_dependencies'] ?? {});

  final all = {
    ...dependencies,
    ...devDependencies,
  };

  return filterPackages(all);
}

Map<String, String> filterPackages(Map<String, dynamic> json) {
  final Map<String, String> pkgs = {};

  json.map((key, value) {
    if (value is String) {
      pkgs[key] = value;
    }
    return MapEntry(key, value);
  });

  return pkgs;
}