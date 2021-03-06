import 'dart:io';

import 'package:path/path.dart' as path;

bool _hasPubGetRun = false;

void pubGetFixtures() {
  if (_hasPubGetRun) {
    return;
  }

  Directory('test/fixtures/').listSync().whereType<Directory>().forEach((d) {
    if (!d
        .listSync()
        .whereType<File>()
        .any((f) => f.path.endsWith('${path.separator}pubspec.yaml'))) {
      return;
    }

    final result = Process.runSync('pub', ['get'], workingDirectory: d.path);
    if (result.exitCode != 0) {
      throw ProcessException(
        'pub',
        ['get'],
        'pub get failed on fixture ${d.path}',
        result.exitCode,
      );
    }
  });

  _hasPubGetRun = true;
}

ProcessResult runWith(Iterable<String> arguments, String against) =>
    Process.runSync(
      'pub',
      [
        '--trace',
        'run',
        'dcdg',
      ]..addAll(arguments),
      workingDirectory: against,
    );
