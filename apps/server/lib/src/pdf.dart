import 'dart:typed_data';

import 'font.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<Uint8List> requestPdf(String name, String subject, String text) async {
  final font = pw.Font.ttf(demoFontBytes);
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: font, bold: font),
  );
  doc.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(48),
      build: (_) => [
        pw.Text(
          'DO PAPEL AO DIGITAL',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('Registro de requerimento escolar'),
        pw.Divider(),
        pw.SizedBox(height: 24),
        pw.Text(
          'REQUERIMENTO ESCOLAR',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 24),
        pw.Text('Solicitante: $name'),
        pw.SizedBox(height: 12),
        pw.Text('Assunto: $subject'),
        pw.SizedBox(height: 24),
        pw.Text(text),
        pw.SizedBox(height: 32),
        pw.Text('Data: ${DateTime.now().toIso8601String().substring(0, 10)}'),
        pw.SizedBox(height: 64),
        pw.Text('________________________________________'),
        pw.Text('Assinatura do solicitante'),
        pw.SizedBox(height: 24),
        pw.Text(
          'Confira os dados antes de encaminhar este requerimento.',
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    ),
  );
  return doc.save();
}

Future<Uint8List> reportPdf(Map<String, dynamic> report) async {
  final font = pw.Font.ttf(demoFontBytes);
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: font, bold: font),
  );
  doc.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(36),
      footer: (c) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Página ' + c.pageNumber.toString(),
          style: const pw.TextStyle(fontSize: 9),
        ),
      ),
      build: (_) => [
        pw.Text(
          'BOLETIM DE ACOMPANHAMENTO',
          style: pw.TextStyle(fontSize: 19, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.Text(report['student']['name']),
        pw.Text(
          'Identificação: ' +
              (report['student']['registration'] ?? 'Não informada'),
        ),
        pw.Text('Emitido em: ' + report['issued'].toString().substring(0, 10)),
        pw.SizedBox(height: 18),
        if ((report['summaries'] as List).isNotEmpty)
          pw.TableHelper.fromTextArray(
            headerAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#E8F0F3'),
            ),
            oddRowDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F7F9FA'),
            ),
            border: pw.TableBorder.all(color: PdfColors.grey400, width: .4),
            headers: [
              'Disciplina / etapa',
              'Média de acompanhamento (0–10)',
              'Sem nota numérica',
            ],
            data: [
              for (final summary in report['summaries'])
                [
                  summary['subject'] + ' / ' + summary['stage'],
                  summary['average'] == null
                      ? '—'
                      : (summary['average'] as num).toStringAsFixed(2) +
                            (summary['missing_count'] > 0 ? ' (parcial)' : ''),
                  summary['missing_count'].toString(),
                ],
            ],
            headerStyle: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellPadding: const pw.EdgeInsets.all(6),
          ),
        pw.SizedBox(height: 14),
        if ((report['grades'] as List).isEmpty)
          pw.Text('Nenhuma avaliação publicada.'),
        if ((report['grades'] as List).isNotEmpty)
          pw.TableHelper.fromTextArray(
            headerAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#E8F0F3'),
            ),
            oddRowDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F7F9FA'),
            ),
            border: pw.TableBorder.all(color: PdfColors.grey400, width: .4),
            columnWidths: const {
              0: pw.FlexColumnWidth(1.2),
              1: pw.FlexColumnWidth(2.5),
              2: pw.FlexColumnWidth(2.1),
              3: pw.FlexColumnWidth(1.1),
              4: pw.FlexColumnWidth(1.2),
            },
            headers: [
              'Ano / turma',
              'Disciplina / fase',
              'Etapa / avaliação',
              'Nota / máximo',
              'Situação',
            ],
            data: [
              for (final g in report['grades'])
                [
                  g['school_year'].toString() + ' / ' + g['class_name'],
                  g['subject'] + ' / ' + (g['phase'] ?? ''),
                  g['stage'] + ' / ' + g['label'],
                  g['score'] == null
                      ? '—'
                      : g['score'].toString() +
                            ' / ' +
                            g['max_score'].toString(),
                  g['status'],
                ],
            ],
            headerStyle: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellPadding: const pw.EdgeInsets.all(6),
          ),
        pw.SizedBox(height: 18),
        pw.Text(
          'FREQUÊNCIA PUBLICADA',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if ((report['attendance'] as List).isEmpty)
          pw.Text('Nenhuma aula publicada.'),
        if ((report['attendance'] as List).isNotEmpty)
          pw.TableHelper.fromTextArray(
            headerAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#E8F0F3'),
            ),
            oddRowDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F7F9FA'),
            ),
            border: pw.TableBorder.all(color: PdfColors.grey400, width: .4),
            headers: ['Data', 'Turma / disciplina', 'Aulas', 'Registro'],
            data: [
              for (final a in report['attendance'])
                [
                  a['date'],
                  a['class_name'] + ' / ' + a['subject'],
                  a['units'].toString(),
                  a['status'],
                ],
            ],
            headerStyle: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellPadding: const pw.EdgeInsets.all(6),
          ),
        pw.SizedBox(height: 14),
        pw.Text(report['calculation'], style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(height: 8),
        pw.Text(
          'Extrato de acompanhamento dos registros publicados. Não substitui histórico escolar ou certificado oficial.',
          style: const pw.TextStyle(fontSize: 9),
        ),
      ],
    ),
  );
  return doc.save();
}
