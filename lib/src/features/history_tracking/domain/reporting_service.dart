// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../medication_management/domain/entities/medicine.dart';
import '../../medication_management/domain/entities/adherence_log.dart';

class ReportingService {
  Future<Uint8List> generateAdherenceReport(
      Medicine medicine, List<AdherenceLog> logs) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Adherence Report: ${medicine.name}',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Dosage: ${medicine.dosage}'),
              pw.Text('Interval: ${medicine.intervalType.name}'),
              pw.SizedBox(height: 32),
              pw.TableHelper.fromTextArray(
                context: context,
                data: const <List<String>>[
                  <String>['Date', 'Scheduled', 'Taken', 'Status', 'Notes'],
                  // Data rows will be injected here
                ] + logs.map((l) => [
                  l.scheduledTime.toString().split(' ')[0], // Date
                  '${l.scheduledTime.hour}:${l.scheduledTime.minute}',
                  l.takenTime != null ? '${l.takenTime!.hour}:${l.takenTime!.minute}' : '-',
                  l.status.name,
                  l.mealNotes ?? '-',
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> printOrShareReport(Uint8List pdfBytes, String fileName) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: fileName,
    );
  }
}
