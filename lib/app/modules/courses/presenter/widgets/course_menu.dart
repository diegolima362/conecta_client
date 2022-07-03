import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';
import 'package:conecta/app/modules/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../details/course_details_store.dart';
import '../registrations/registrations_store.dart';

class CourseMenu extends StatelessWidget {
  final bool owner;
  final CourseEntity course;
  const CourseMenu({
    Key? key,
    required this.course,
    required this.owner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registrationsStore = Modular.get<RegistrationsStore>();

    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return IconButton(
        icon: const Icon(Icons.more_vert),
        tooltip: 'Opções',
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            useRootNavigator: false,
            isScrollControlled: true,
            builder: (context) => CustomModal(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    const SectionTitle(text: 'Opções'),
                    if (owner) ...[
                      ListTile(
                        title: const Text('Editar'),
                        trailing: const Icon(Icons.edit_sharp),
                        onTap: () async {
                          Navigator.of(context).pop();

                          Modular.to.pushNamed(
                            '/app/courses/edit/${course.id}/',
                          );
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Deletar Curso',
                        ),
                        trailing: const Icon(Icons.delete_forever),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await deleteCourse(context);
                        },
                      ),
                    ] else
                      ListTile(
                        title: const Text(
                          'Sair do Curso',
                        ),
                        trailing: const Icon(Icons.logout),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          registrationsStore.leaveCourse();
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return PopupMenuButton(
        icon: Icon(
          Icons.menu,
          color: context.colors.primary,
        ),
        itemBuilder: (context) => <PopupMenuEntry>[
          if (owner) ...[
            PopupMenuItem(
              onTap: () async {
                Modular.to.pushNamed(
                  '/app/courses/edit/${course.id}/',
                );
              },
              child: const ListTile(
                title: Text('Editar'),
                trailing: Icon(Icons.edit_sharp),
              ),
            ),
            PopupMenuItem(
              child: const ListTile(
                title: Text('Deletar Curso'),
                trailing: Icon(Icons.delete_forever),
              ),
              onTap: () async {
                await deleteCourse(
                  context,
                  useRootNavigator: true,
                );
              },
            ),
          ] else
            const PopupMenuItem(
              onTap: null,
              child: ListTile(
                title: Text('Sair do Curso'),
                trailing: Icon(Icons.logout),
              ),
            ),
        ],
      );
    }
  }

  Future<void> deleteCourse(BuildContext context,
      {bool useRootNavigator = false}) {
    return showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (context) => AlertDialog(
        title: const Text('Apagar'),
        content: const Text(
          'Tem certeza que quer apagar o curso?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            onPressed: () => _delete(context),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    Navigator.pop(context);
    await Modular.get<CourseDetailsStore>().deleteCourse();
    await Modular.get<HomeStore>().getData(cached: false);

    Modular.to.navigate('/app/home/');
  }
}
