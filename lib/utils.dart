class VersionCompare {
  const VersionCompare(
    this.name,
    this.currentVersion,
    this.lastestVersion, {
    this.hasUpdate
  });

  final String name;

  final String currentVersion;

  final String lastestVersion;

  final bool hasUpdate;
}