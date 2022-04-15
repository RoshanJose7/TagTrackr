import 'dart:io';

import 'package:image_picker/image_picker.dart';
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
  File jsonFile = File("$path/$fileName");
  if (!(await jsonFile.exists())) await jsonFile.create();

  return await jsonFile.writeAsString(data);
}

Future<List<XFile>?> getFiles() async {
  final ImagePicker _picker = ImagePicker();
  final List<XFile>? images = await _picker.pickMultiImage();
  return images;
}
