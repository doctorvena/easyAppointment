// // report_service.dart

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pdfWidgets;
// import 'package:printing/printing.dart';

// class ReportService {
//   static Future<void> generateAndPreviewReport() async {
//     final pdfDoc = _generateDocument();

//     // To preview the PDF
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdfDoc.save(),
//     );
//   }

//   static pdfWidgets.Document _generateDocument() {
//     final pdf = pdfWidgets.Document();

//     pdf.addPage(
//       pdfWidgets.Page(
//         build: (pdfWidgets.Context context) => pdfWidgets.Center(
//           child: pdfWidgets.Text("We made it", style: pdfWidgets.TextStyle(fontSize: 40)),
//         ),
//       ),
//     );

//     return pdf;
//   }
// }
