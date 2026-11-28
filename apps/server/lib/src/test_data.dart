import 'academics.dart';
import 'journals.dart';

import 'dart:io';

import 'pdf.dart';
import 'operations.dart';
import 'school.dart';
import 'store.dart';
import 'templates.dart';

Future<void> seedTestAcademics(Store s) async {
  final school = School(s), operations = Operations(s);
  final journals = Journals(s, school);
  final academic = Academics(s, school, journals);
  final date = DateTime.now();
  final year = date.year, today = date.toIso8601String().substring(0, 10);
  await s.db.transaction(() async {
    if ((await s.db.rows('SELECT id FROM courses LIMIT 1')).isNotEmpty) return;
    final admin = await s.one('users', 'admin');
    await s.db.exec(
      "INSERT OR IGNORE INTO users VALUES('docente2','Lia Santos','professor',NULL)",
    );
    await s.db.exec(
      "INSERT OR IGNORE INTO users VALUES('responsavel','Marina Oliveira','responsavel',NULL)",
    );
    final template = await Templates(s).save(admin, {
      'name': 'Pasta de teste',
      'documents': ['Identificação', 'Histórico'],
    });
    final course = await school.saveCourse(admin, {
      'name': 'Curso de teste',
      'modality': 'Integrado',
      'template': template,
    });
    final subject = await academic.saveSubject(admin, {'name': 'Laboratório'});
    final awaitingEnrollment = await s.createStudent(admin, {
      'name': 'Rafael Costa',
      'registration': 'TESTE-02',
      'template': template,
    });
    String? student;
    for (final duration in [45, 50]) {
      final phase = 'Fase ${duration == 45 ? 1 : 2}';
      await academic.saveComponent(admin, {
        'course': course,
        'subject': subject,
        'phase': phase,
        'hours': 40,
        'lesson_minutes': duration,
      });
      final model = await operations.saveModel(admin, {
        'name': 'Matutino $duration min',
        'valid_from': '$year-01-01',
        'valid_to': '$year-12-31',
        'periods': [
          {
            'label': '1ª aula',
            'start_minute': duration == 45 ? 420 : 480,
            'end_minute': duration == 45 ? 465 : 530,
          },
        ],
      });
      final group = await school.createClass(admin, {
        'course': course,
        'name': 'LAB-$duration',
        'school_year': year,
        'period_label': phase,
        'grade': phase,
        'shift': 'Matutino',
        'capacity': 30,
        'period_model': model,
      });
      final journal = (await journals.list(admin, group)).single;
      await operations.assign(admin, journal['id'], {
        'revision': journal['revision'],
        'teachers': [
          for (final teacher in ['professor', if (duration == 45) 'docente2'])
            {
              'teacher': teacher,
              'valid_from': '$year-01-01',
              'valid_to': '$year-12-31',
            },
        ],
      });
      student ??= await s.createStudent(admin, {
        'name': 'Ana Oliveira',
        'registration': 'TESTE-01',
        'template': template,
      });
      await s.db.exec(
        "INSERT OR IGNORE INTO student_access VALUES(?,'aluno'),(?,'responsavel')",
        [student, student],
      );
      if (duration == 45) {
        final id = uuid.v4();
        final bytes = await requestPdf(
          'Ana Oliveira',
          'Identificação de teste',
          'Documento fictício para conferir a pasta do aluno.',
        );
        await File('${s.files.path}/$id').writeAsBytes(bytes, flush: true);
        await s.db.exec(
          'INSERT INTO documents(id,name,folder,type,mime,size,storage,uploader,created,updated) VALUES(?,?,?,?,?,?,?,?,?,?)',
          [
            id,
            'Identificação de teste.pdf',
            (await s.one('students', student))['folder'],
            'Identificação',
            'application/pdf',
            bytes.length,
            id,
            'aluno',
            now(),
            now(),
          ],
        );
      }
      final enrollment = await school.enroll(admin, {
        'student': student,
        'class_group': group,
      });
      if (duration == 50) {
        await school.enroll(admin, {
          'student': awaitingEnrollment,
          'class_group': group,
        });
      }
      await school.changeEnrollment(admin, enrollment, {
        'revision': 1,
        'action': 'activate',
        'note': 'Cenário fictício para testes.',
      });
      await academic.saveSlot(admin, {
        'journal': journal['id'],
        'weekday': 1,
        'start_minute': duration == 45 ? 420 : 480,
        'end_minute': duration == 45 ? 465 : 530,
        'valid_from': '$year-01-01',
        'valid_to': '$year-12-31',
        'room': 'Sala de teste',
      });
      final lesson = await journals.saveLesson(admin, journal['id'], {
        'date': today,
        'units': 2,
        'content': 'Atividade de laboratório',
        'attendance': [
          {'enrollment': enrollment, 'status': 'Ausente', 'absences': 1},
        ],
      });
      await journals.action(admin, lesson, {'revision': 1, 'action': 'submit'});
      if (duration == 45)
        await journals.action(admin, lesson, {
          'revision': 2,
          'action': 'publish',
        });
      final assessment = await academic.saveAssessment(admin, journal['id'], {
        'label': 'Atividade prática',
        'stage': 'Etapa 1',
        'held_on': today,
        'max_score': 10,
        'weight': 1,
        'grades': [
          {'enrollment': enrollment, 'status': 'Lançada', 'score': 8.5},
        ],
      });
      await academic.assessmentAction(admin, assessment, {
        'revision': 1,
        'action': 'submit',
      });
      if (duration == 45)
        await academic.assessmentAction(admin, assessment, {
          'revision': 2,
          'action': 'publish',
        });
    }
  });
}
