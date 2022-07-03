import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/article_content.dart';
import 'package:conecta/app/core/presenter/widgets/filled_button.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

import 'assignments_store.dart';

class EditAssignmentPage extends HookWidget {
  final AssignmentEntity? assignment;
  const EditAssignmentPage({Key? key, this.assignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController =
        useTextEditingController(text: assignment?.title ?? '');
    final bodyController =
        useTextEditingController(text: assignment?.content ?? '');
    final gradeController =
        useTextEditingController(text: (assignment?.grade ?? 100).toString());
    final filled = useState(false);

    final date = useState(assignment?.dueDate ?? DateTime.now());

    final store = Modular.get<AssignmentsStore>();

    return Scaffold(
      appBar: AppBar(),
      body: ArticleContent(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Título'),
                    controller: titleController,
                    validator: (text) =>
                        (text?.isEmpty ?? true) ? 'Informe um título' : null,
                    onChanged: (value) {
                      filled.value = bodyController.text.isNotEmpty &&
                          titleController.text.isNotEmpty;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Pontuação'),
                    keyboardType: TextInputType.number,
                    controller: gradeController,
                    onChanged: (value) {
                      filled.value = bodyController.text.isNotEmpty &&
                          titleController.text.isNotEmpty &&
                          int.tryParse(gradeController.text) != null;
                    },
                    validator: (text) {
                      final grade = int.tryParse(text ?? '');

                      return (text?.isEmpty ?? true) &&
                              grade != null &&
                              grade >= 0
                          ? 'Informe uma pontuação válida'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  RemiderDateStep(date: date),
                  const SizedBox(height: 16),
                  MarkdownTextInput(
                    (value) {
                      bodyController.text = value;
                      filled.value = bodyController.text.isNotEmpty &&
                          titleController.text.isNotEmpty;
                    },
                    bodyController.text,
                    maxLines: null,
                    actions: MarkdownType.values,
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: filled,
                    builder: (context, _) {
                      return FilledButton(
                        context,
                        onPressed: filled.value
                            ? () async {
                                FocusScope.of(context).unfocus();

                                Navigator.of(context).pop();

                                if (assignment != null) {
                                  await store.editAssignemnt(
                                    assignmentId: assignment!.id,
                                    title: titleController.text,
                                    content: bodyController.text,
                                    grade: int.tryParse(gradeController.text) ??
                                        100,
                                    dueDate: date.value,
                                  );
                                } else {
                                  await store.createAssignment(
                                    title: titleController.text,
                                    content: bodyController.text,
                                    grade: int.tryParse(gradeController.text) ??
                                        100,
                                    dueDate: date.value,
                                  );
                                }
                              }
                            : null,
                        child: const Text('Salvar'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RemiderDateStep extends StatelessWidget {
  const RemiderDateStep({
    Key? key,
    required this.date,
  }) : super(key: key);

  final ValueNotifier<DateTime> date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    useRootNavigator: false,
                    initialDate: date.value,
                    firstDate: date.value,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialEntryMode: DatePickerEntryMode.calendar,
                  );
                  if (picked != null) {
                    date.value = picked;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    )),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(date.value.simpleDate.toUpperCase()),
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    useRootNavigator: false,
                    initialEntryMode: TimePickerEntryMode.input,
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(date.value),
                  );

                  if (picked != null) {
                    date.value = picked.toDateTime(date.value);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    )),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(date.value.hours)),
                      const Icon(Icons.alarm_sharp),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
