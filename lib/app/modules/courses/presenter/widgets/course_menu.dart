import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/presenter/details/course_details_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CourseMenu extends StatelessWidget {
  final bool owner;
  const CourseMenu({Key? key, required this.owner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<CourseDetailsStore>();

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
                    ListTile(
                      title: const Text('Editar'),
                      trailing: const Icon(Icons.edit_sharp),
                      onTap: () async {
                        Navigator.of(context).pop();

                        store.state.course.match(
                          (t) {
                            Modular.to.pushNamed('/app/courses/edit/${t.id}/');
                          },
                          () => null,
                        );
                      },
                    ),
                    if (owner)
                      ListTile(
                        title: const Text(
                          'Deletar Curso',
                        ),
                        trailing: const Icon(Icons.delete_forever),
                        onTap: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          await store.delete();
                        },
                      )
                    else
                      const ListTile(
                        title: Text(
                          'Sair do Curso',
                        ),
                        trailing: Icon(Icons.logout),
                        onTap: null,
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
          PopupMenuItem(
            onTap: () async {
              store.state.course.match(
                (t) {
                  Modular.to.pushNamed('/app/courses/edit/${t.id}/');
                },
                () => null,
              );
            },
            child: const ListTile(
              title: Text('Editar'),
              trailing: Icon(Icons.edit_sharp),
            ),
          ),
          if (owner)
            PopupMenuItem(
              child: const ListTile(
                title: Text('Deletar Curso'),
                trailing: Icon(Icons.delete_forever),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                await store.delete();
              },
            )
          else
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
}
