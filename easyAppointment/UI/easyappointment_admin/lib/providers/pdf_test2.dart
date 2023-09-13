import 'dart:io';

import 'package:eprodaja_admin/providers/pdf_provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../models/reservation.dart';
import '../models/search_result.dart';

class PdfReservationReportApi {
  static Future<File> generate(searchResult<Reservation> reservations) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(),
        buildReservationsTable(reservations),
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(name: 'reservations_report2.pdf', pdf: pdf);
  }

  static Widget buildHeader() => Center(
        child: Text(
          'Reservation Report',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text('List of Reservations'),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildReservationsTable(searchResult<Reservation> reservations) {
    final headers = [
      'Reservation Name',
      'Status',
      'Reservation Date',
      'Price',
      'Is Paid'
    ];

    final data = reservations.result.map((reservation) {
      return [
        reservation.reservationName ?? '',
        reservation.status ?? '',
        reservation.reservationDate != null
            ? DateFormat('EEEE, MMM dd, yyyy')
                .format(reservation.reservationDate!)
            : '',
        reservation.price != null
            ? '\$ ${reservation.price?.toStringAsFixed(2)}'
            : '',
        reservation.isPaid != null
            ? (reservation.isPaid! ? 'Yes' : 'No')
            : 'N/A'
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerRight,
        4: Alignment.centerLeft,
      },
    );
  }

  static Widget buildFooter() => Center(
        child: Text('End of Reservations Report'),
      );
}
