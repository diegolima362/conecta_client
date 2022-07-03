import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/profile/profile_avatar.dart';
import 'package:flutter/material.dart';

class FeedPostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;
  const FeedPostCard({
    Key? key,
    required this.post,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        color: context.colors.surface,
        elevation: 2,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: ProfileAvatar(
                  name: post.authorName,
                  radius: 25,
                  fontSize: 24,
                ),
                title: Text(post.authorName),
                subtitle: Text(post.creationDate.simpleDate),
              ),
              const Divider(height: 0),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  post.title,
                  maxLines: 3,
                  style: context.textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Text(
                  post.content,
                  maxLines: 3,
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
