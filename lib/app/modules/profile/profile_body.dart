import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final UserEntity profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileCardItem(text: 'Usuário', value: profile.username),
        const SizedBox(height: 8),
        _ProfileCardItem(text: 'Email', value: profile.email),
        const SizedBox(height: 8),
        if (profile.admin)
          const _ProfileCardItem(text: 'Professor', value: '👑'),
      ],
    );
  }
}

class _ProfileCardItem extends StatelessWidget {
  final String text;
  final String value;

  const _ProfileCardItem({Key? key, required this.text, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: textTheme.bodyLarge),
          Text(value, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
