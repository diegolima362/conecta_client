import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/domain/entities/registration_entity.dart';
import 'package:conecta/app/modules/profile/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'registrations_store.dart';

class RegistrationsPage extends StatefulWidget {
  final int courseId;

  const RegistrationsPage({super.key, required this.courseId});

  @override
  State<RegistrationsPage> createState() => _RegistrationsPageState();
}

class _RegistrationsPageState extends State<RegistrationsPage> {
  late final RegistrationsStore store;
  @override
  void initState() {
    super.initState();
    store = Modular.get();

    store.getData(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: ScopedBuilder<RegistrationsStore, AppContentFailure,
            List<RegistrationEntity>>(
          store: store,
          onLoading: (_) => const LoadingIndicator(),
          onError: (_, error) => EmptyCollection.error(message: ''),
          onState: (context, state) {
            if (state.isEmpty) {
              return const EmptyCollection(
                text: "Sem Alunos Registrados!",
                icon: Icons.person_off_outlined,
              );
            }

            return ArticleContent(
              child: ListView.builder(
                itemCount: state.length,
                itemBuilder: (context, index) {
                  final registration = state[index];

                  return ListTile(
                    leading: ProfileAvatar(
                      name: registration.studentName,
                      fontSize: 24,
                    ),
                    title: Text(registration.studentName),
                    subtitle: Text(registration.studentEmail),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }
}
