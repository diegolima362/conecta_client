import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

import 'profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final UserEntity profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileAvatar(name: profile.name),
        const SizedBox(height: 24),
        Text(
          profile.name,
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
