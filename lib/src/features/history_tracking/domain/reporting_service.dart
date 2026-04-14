import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../medication_management/domain/entities/adherence_log.dart';
import '../../medication_management/domain/entities/medicine.dart';

class ReportingService {
  ReportingService._();

  static Future<void> generateAdherenceReport({
    required Medicine medicine,
    required List<AdherenceLog> logs,
  }) async {
    final pw.Document pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text(
                'Adherence Report: ${medicine.name}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Dosage: ${medicine.dosage}'),
              pw.SizedBox(height: 10),
              pw.Divider(),
              ...logs.map(
                (AdherenceLog log) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(log.scheduledTime.toString()),
                      pw.Text(log.status.name.toUpperCase()),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
  }
}
