import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'course_details_store.dart';

class CourseEditPage extends StatefulWidget {
  final int? courseId;
  const CourseEditPage({Key? key, required this.courseId}) : super(key: key);

  @override
  State<CourseEditPage> createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  late final TextEditingController titleController;
  late final CourseDetailsStore store;

  late final ValueNotifier<bool> filled;

  @override
  void initState() {
    super.initState();

    store = Modular.get();

    filled = ValueNotifier(false);

    titleController = TextEditingController();

    if (widget.courseId != null) {
      store.getData(widget.courseId!).then(
            (value) => titleController.text =
                store.state.course.toNullable()?.name ?? '',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseId != null ? 'Editar Curso' : 'Criar Curso'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ArticleContent(
          maxWidth: constraints.isMobile ? constraints.maxWidth : 600,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    controller: titleController,
                    textInputAction: TextInputAction.next,
                    onChanged: (text) => filled.value = text.isNotEmpty,
                    onEditingComplete: () async {
                      FocusScope.of(context).unfocus();

                      submit(titleController.text);

                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: filled,
                    builder: (context, _) {
                      return FilledButton(
                        context,
                        onPressed: filled.value
                            ? () {
                                FocusScope.of(context).unfocus();
                                submit(titleController.text);

                                Navigator.of(context).pop();
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

  Future<void> submit(String title) async {
    if (title.isNotEmpty) {
      if (widget.courseId != null) {
        store.editCourse(titleController.text);
      } else {
        final user = await Modular.get<IGetLoggedUser>()();

        final id = user.fold((l) => 0, (r) => r.toNullable()?.id ?? 0);

        if (id != 0) {
          store.createCourse(titleController.text, id);
        }
      }
    }
  }
}
