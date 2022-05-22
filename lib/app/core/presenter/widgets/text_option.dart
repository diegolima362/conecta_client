import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:flutter/material.dart';

class TextOption extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? leading;
  final String label;
  final bool selected;

  const TextOption({
    Key? key,
    this.onTap,
    this.leading,
    required this.label,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      trailing: const SizedBox.shrink(),
      leading: leading ?? const SizedBox.shrink(),
      title: Text(
        label,
        style: TextStyle(color: context.colors.primary),
      ),
      onTap: onTap,
    );
  }
}
