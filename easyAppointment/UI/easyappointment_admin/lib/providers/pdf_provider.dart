import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateCenteredText(String text,
      [String? subtitle]) async {
    final pdf = Document();

    pdf.addPage(Page(
      build: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(fontSize: 48)),
            SizedBox(height: 20),
            if (subtitle != null)
              Text(subtitle,
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    ));

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    int counter = 1;
    String fileName = name;

    while (await File('${dir.path}/$fileName').exists()) {
      fileName = name.replaceFirst('.pdf', '_$counter.pdf');
      counter++;
    }

    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }
}
