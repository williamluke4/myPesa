import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> selectFile() async {
  String? filePath;
  if (Platform.isAndroid || Platform.isIOS) {
    filePath = await FlutterFileDialog.pickFile(
      params: const OpenFileDialogParams(),
    );
  } else {
    final result = await FilePicker.platform.pickFiles();
    filePath = result?.files.single.path;
  }
  if (filePath != null) {
    return File(filePath);
  }
  return null;
}

Future<String?> saveToFile(String fileName, String data) async {
  final directory = await getTemporaryDirectory();

  String? filePath;
  if (Platform.isAndroid || Platform.isAndroid) {
    final file = File('${directory.path}/$fileName');
    if (file.existsSync()) file.deleteSync();

    await file.create(recursive: true);
    await file.writeAsString(data);
    filePath = await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(sourceFilePath: file.path),
    );
  } else {
    filePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Where would you like it:',
      fileName: fileName,
    );
    if (filePath != null) {
      final file = File(filePath);
      await file.create(recursive: true);
      await file.writeAsString(data);
    }
  }
  return filePath;
}
