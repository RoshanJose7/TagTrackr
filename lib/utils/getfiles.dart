import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String?> get downloadDirPath async {
  Directory? directory = Directory('/storage/emulated/0/Download');
  if (!await directory.exists()) {
    directory = await getExternalStorageDirectory();
  }

  return directory?.path;
}

Future<File> createFile(String path, String fileName, String data) async {
  File jsonFile = File("$path/$fileName.json");
  if (!(await jsonFile.exists())) await jsonFile.create();

  return await jsonFile.writeAsString(data);
}

Future<FilePickerResult?> getfiles() async {
  return await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
}
