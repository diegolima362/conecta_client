import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:flutter/material.dart';

class FilledButton extends ElevatedButton {
  FilledButton(
    BuildContext context, {
    Key? key,
    required VoidCallback? onPressed,
    required Widget? child,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: child,
          style: ButtonStyle(
            elevation: MaterialStateProperty.resolveWith((states) => 0),
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) => onPressed != null
                  ? context.colors.primary
                  : context.colors.onSurface.withOpacity(0.12),
            ),
            foregroundColor: MaterialStateProperty.resolveWith(
              (states) => onPressed != null
                  ? context.colors.onPrimary
                  : context.colors.onSurface.withOpacity(0.38),
            ),
            textStyle: MaterialStateProperty.resolveWith(
                (_) => context.textTheme.labelLarge?.copyWith(
                      color: onPressed != null
                          ? context.colors.onPrimary
                          : context.colors.onSurface.withOpacity(0.38),
                    )),
            shape: MaterialStateProperty.resolveWith(
              (_) => const StadiumBorder(),
            ),
            fixedSize: MaterialStateProperty.resolveWith(
              (_) => const Size(double.infinity, 40),
            ),
            minimumSize: MaterialStateProperty.resolveWith(
              (_) => const Size(48, 40),
            ),
          ),
        );
}
