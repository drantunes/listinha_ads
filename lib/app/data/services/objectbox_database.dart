import 'dart:io';

import 'package:listinhax/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxDatabase {
  late final Store store;

  ObjectBoxDatabase._create(this.store);
  static Future<ObjectBoxDatabase> create() async {
    final baseDir = Platform.isMacOS
        ? await getApplicationSupportDirectory()
        : await getApplicationDocumentsDirectory();
    final dbDir = Directory(p.join(baseDir.path, "exemplo"));
    if (!dbDir.existsSync()) {
      await dbDir.create(recursive: true);
    }
    final store = await openStore(
      directory: dbDir.path,
      macosApplicationGroup: Platform.isMacOS ? 'listinhax' : null,
    );
    return ObjectBoxDatabase._create(store);
  }
}

ObjectBoxDatabase? objectBox;
Future<ObjectBoxDatabase> startObjectBox() async {
  return objectBox ??= await ObjectBoxDatabase.create();
}
