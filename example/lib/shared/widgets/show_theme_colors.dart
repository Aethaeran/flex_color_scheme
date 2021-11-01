import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// Draw a number of boxes showing the colors of key theme color properties
/// in the ColorScheme of the inherited ThemeData and some of its key color
/// properties.
///
/// This widget is just used so we can visually see the active theme colors
/// in the examples and their used FlexColorScheme based themes.
class ShowThemeColors extends StatelessWidget {
  const ShowThemeColors({Key? key}) : super(key: key);

  // On color used when a theme color property does not have a theme onColor.
  static Color _onColor(final Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light
          ? Colors.black
          : Colors.white;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color appBarColor = theme.appBarTheme.backgroundColor ??
        (isDark ? colorScheme.surface : colorScheme.primary);

    // Grab the card border from the theme card shape
    ShapeBorder? border = theme.cardTheme.shape;
    // If we had one, copy in a border side to it.
    if (border is RoundedRectangleBorder) {
      border = border.copyWith(
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      );
      // If
    } else {
      // If border was null, make one matching Card default, but with border
      // side, if it was not null, we leave it as it was.
      border ??= RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      );
    }

    // Warning label for scaffold background when it uses to much blend.
    final String scaffoldTooHigh = isDark
        ? theme.scaffoldBackgroundColor.isLight
            ? '\nTOO HIGH'
            : ''
        : theme.scaffoldBackgroundColor.isDark
            ? '\nTOO HIGH'
            : '';
    // Warning label for scaffold background when it uses to much blend.
    final String surfaceTooHigh = isDark
        ? theme.colorScheme.surface.isLight
            ? '\nTOO HIGH'
            : ''
        : theme.colorScheme.surface.isDark
            ? '\nTOO HIGH'
            : '';

    // Warning label for scaffold background when it uses to much blend.
    final String backTooHigh = isDark
        ? theme.colorScheme.background.isLight
            ? '\nTOO HIGH'
            : ''
        : theme.colorScheme.background.isDark
            ? '\nTOO HIGH'
            : '';

    // A Wrap widget is just the right handy widget for this type of
    // widget to make it responsive.
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: 0,
          shape: border,
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'ColorScheme Colors',
              style: theme.textTheme.subtitle1,
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ThemeCard(
                label: 'Primary',
                color: colorScheme.primary,
                textColor: colorScheme.onPrimary,
              ),
              ThemeCard(
                label: 'onPrimary',
                color: colorScheme.onPrimary,
                textColor: colorScheme.primary,
              ),
              ThemeCard(
                label: 'Primary\nVariant',
                color: colorScheme.primaryVariant,
                textColor: _onColor(colorScheme.primaryVariant),
              ),
              ThemeCard(
                label: 'Secondary',
                color: colorScheme.secondary,
                textColor: colorScheme.onSecondary,
              ),
              ThemeCard(
                label: 'onSecondary',
                color: colorScheme.onSecondary,
                textColor: colorScheme.secondary,
              ),
              ThemeCard(
                label: 'Secondary\nVariant',
                color: colorScheme.secondaryVariant,
                textColor: _onColor(colorScheme.secondaryVariant),
              ),
              ThemeCard(
                label: 'Background$backTooHigh',
                color: colorScheme.background,
                textColor: colorScheme.onBackground,
              ),
              ThemeCard(
                label: 'on\nBackground',
                color: colorScheme.onBackground,
                textColor: colorScheme.background,
              ),
              ThemeCard(
                label: 'Surface$surfaceTooHigh',
                color: colorScheme.surface,
                textColor: colorScheme.onSurface,
              ),
              ThemeCard(
                label: 'onSurface',
                color: colorScheme.onSurface,
                textColor: colorScheme.surface,
              ),
              ThemeCard(
                label: 'Error',
                color: colorScheme.error,
                textColor: colorScheme.onError,
              ),
              ThemeCard(
                label: 'onError',
                color: colorScheme.onError,
                textColor: colorScheme.error,
              ),
              ThemeCard(
                label: 'Themed\nAppBar',
                color: appBarColor,
                textColor: _onColor(appBarColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'ThemeData Colors (to be deprecated in SDK)',
              style: theme.textTheme.subtitle1,
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ThemeCard(
                label: 'Primary\nColor',
                color: theme.primaryColor,
                textColor: colorScheme.onPrimary,
              ),
              ThemeCard(
                label: 'Primary\nColorDark',
                color: theme.primaryColorDark,
                textColor: colorScheme.onPrimary,
              ),
              ThemeCard(
                label: 'Primary\nColorLight',
                color: theme.primaryColorLight,
                textColor: _onColor(theme.primaryColorLight),
              ),
              ThemeCard(
                label: 'Secondary\nHeaderColor',
                color: theme.secondaryHeaderColor,
                textColor: _onColor(theme.secondaryHeaderColor),
              ),
              ThemeCard(
                label: 'Toggleable\nActive',
                color: theme.toggleableActiveColor,
                textColor: colorScheme.onSecondary,
              ),
              ThemeCard(
                label: 'Bottom\nAppBarColor',
                color: theme.bottomAppBarColor,
                textColor: _onColor(theme.bottomAppBarColor),
              ),
              ThemeCard(
                label: 'Divider\nColor',
                color: theme.dividerColor,
                textColor: colorScheme.onBackground,
              ),
              ThemeCard(
                label: 'Disabled\nColor',
                color: theme.disabledColor,
                textColor: colorScheme.onBackground,
              ),
              ThemeCard(
                label: 'CanvasColor$backTooHigh',
                color: theme.canvasColor,
                textColor: colorScheme.onBackground,
              ),
              ThemeCard(
                label: 'CardColor$surfaceTooHigh',
                color: theme.cardColor,
                textColor: colorScheme.onSurface,
              ),
              ThemeCard(
                label: 'DialogBg\nColor',
                color: theme.dialogBackgroundColor,
                textColor: colorScheme.onSurface,
              ),
              ThemeCard(
                label: 'Scaffold\nbackground$scaffoldTooHigh',
                color: theme.scaffoldBackgroundColor,
                textColor: colorScheme.onBackground,
              ),
              ThemeCard(
                label: 'Error\nColor',
                color: theme.errorColor,
                textColor: colorScheme.onError,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// This is just simple SizedBox with a Card with a passed in label, background
/// and text label color. Used to show the colors of a theme color property.
class ThemeCard extends StatelessWidget {
  const ThemeCard({
    Key? key,
    required this.label,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: 80,
      child: Card(
        margin: EdgeInsets.zero,
        color: color,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
