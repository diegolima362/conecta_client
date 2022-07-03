import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/article_content.dart';
import 'package:conecta/app/core/presenter/widgets/filled_button.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

import 'submissions_store.dart';

class SubmissionEditPage extends StatefulWidget {
  final AssignmentEntity assignment;
  final AssignmentSubmissionEntity submission;

  const SubmissionEditPage(
      {super.key, required this.assignment, required this.submission});

  @override
  State<SubmissionEditPage> createState() => _SubmissionEditPageState();
}

class _SubmissionEditPageState extends State<SubmissionEditPage> {
  late final SubmissionsStore store;

  late final TextEditingController bodyController;

  late final ValueNotifier<bool> filled;

  @override
  void initState() {
    super.initState();

    bodyController = TextEditingController(text: widget.submission.content);

    filled = ValueNotifier(false);

    store = Modular.get();
  }

  @override
  void dispose() {
    bodyController.dispose();

    filled.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregar Atividade'),
      ),
      body: ArticleContent(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.assignment.title,
                    style: context.textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Prazo: ${widget.assignment.dueDate.fullDate}',
                    style: context.textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 16),
                MarkdownTextInput(
                  (value) {
                    bodyController.text = value;
                    filled.value = bodyController.text.isNotEmpty;
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

                              await store.submitAssignment(
                                  widget.assignment, bodyController.text);
                            }
                          : null,
                      child: const Text('Entregar'),
                    );
                  },
                ),
              ],
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
