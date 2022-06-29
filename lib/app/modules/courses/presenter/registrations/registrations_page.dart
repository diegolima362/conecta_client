import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/profile/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../details/course_details_store.dart';

class RegistrationsPage extends StatefulWidget {
  const RegistrationsPage({super.key});

  @override
  State<RegistrationsPage> createState() => _RegistrationsPageState();
}

class _RegistrationsPageState extends State<RegistrationsPage> {
  late final CourseDetailsStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: ScopedBuilder<CourseDetailsStore, AppContentFailure,
            CoursetDetailsState>(
          store: store,
          onLoading: (_) => const LoadingIndicator(),
          onError: (_, error) => EmptyCollection.error(message: ''),
          onState: (context, state) {
            if (state.registrations.isEmpty) {
              return const EmptyCollection(
                text: "Sem Alunos Registrados!",
                icon: Icons.person_off_outlined,
              );
            }

            return ArticleContent(
              child: ListView.builder(
                itemCount: state.registrations.length,
                itemBuilder: (context, index) {
                  final registration = state.registrations[index];

                  return ListTile(
                    leading: ProfileAvatar(
                      name: registration.studentName,
                      fontSize: 24,
                      radius: 24,
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
