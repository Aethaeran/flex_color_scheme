import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../../../shared/const/app.dart';
import '../../../../shared/controllers/theme_controller.dart';
import '../../../../shared/utils/link_text_span.dart';
import '../../../../shared/widgets/universal/list_tile_reveal.dart';
import '../../../../shared/widgets/universal/showcase_material.dart';
import '../../../../shared/widgets/universal/slider_list_tile_reveal.dart';
import '../../shared/color_scheme_popup_menu.dart';

class ChipSettings extends StatelessWidget {
  const ChipSettings(this.controller, {super.key});
  final ThemeController controller;

  static final Uri _fcsFlutterIssue115827 = Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'flutter/flutter/issues/115827',
  );

  static final Uri _fcsChipUmbrellaIssue115364 = Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'flutter/flutter/issues/115364',
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool useMaterial3 = theme.useMaterial3;
    final TextStyle spanTextStyle = theme.textTheme.bodySmall!;
    final TextStyle linkStyle = theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary, fontWeight: FontWeight.bold);

    // The most common logic for enabling Playground controls.
    final bool enableControl =
        controller.useSubThemes && controller.useFlexColorScheme;

    // Get effective platform default global radius.
    final double? effectiveRadius = App.effectiveRadius(controller);

    final String chipRadiusDefaultLabel =
        controller.chipBorderRadius == null && effectiveRadius == null
            ? '8 dp'
            : controller.chipBorderRadius == null &&
                    controller.defaultRadius != null
                ? 'global ${effectiveRadius!.toStringAsFixed(0)} dp'
                : '';

    // TODO(rydmike): Add choice chip SchemeColor selected color.
    // TODO(rydmike): Make the blend color vanilla background.
    // TODO(rydmike): Add blended background as optional toggle.
    // TODO(rydmike): Add Chip padding settings.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        ColorSchemePopupMenu(
          title: const Text('Chip blend color'),
          defaultLabel:
              useMaterial3 ? 'default (surface)' : 'default (primary)',
          value: controller.chipSchemeColor?.index ?? -1,
          onChanged: enableControl
              ? (int index) {
                  if (index < 0 || index >= SchemeColor.values.length) {
                    controller.setChipSchemeColor(null);
                  } else {
                    controller.setChipSchemeColor(SchemeColor.values[index]);
                  }
                }
              : null,
        ),
        ColorSchemePopupMenu(
          title: const Text('Selected Chip color'),
          defaultLabel:
              useMaterial3 ? 'default (secondaryContainer)' : 'default (none)',
          value: controller.chipSelectedSchemeColor?.index ?? -1,
          onChanged: enableControl
              ? (int index) {
                  if (index < 0 || index >= SchemeColor.values.length) {
                    controller.setChipSelectedSchemeColor(null);
                  } else {
                    controller
                        .setChipSelectedSchemeColor(SchemeColor.values[index]);
                  }
                }
              : null,
        ),
        ColorSchemePopupMenu(
          title: const Text('Chip delete icon color'),
          defaultLabel: 'default (onSurface)',
          value: controller.chipDeleteIconSchemeColor?.index ?? -1,
          onChanged: enableControl
              ? (int index) {
                  if (index < 0 || index >= SchemeColor.values.length) {
                    controller.setChipDeleteIconSchemeColor(null);
                  } else {
                    controller.setChipDeleteIconSchemeColor(
                        SchemeColor.values[index]);
                  }
                }
              : null,
        ),
        SliderListTileReveal(
          enabled: enableControl,
          title: const Text('Border radius'),
          value: controller.chipBorderRadius,
          onChanged: controller.setChipBorderRadius,
          min: 0,
          max: 40,
          divisions: 40,
          valueDecimalPlaces: 0,
          valueHeading: 'RADIUS',
          valueUnitLabel: ' dp',
          valueDefaultLabel: chipRadiusDefaultLabel,
          valueDefaultDisabledLabel: useMaterial3 ? '8 dp' : 'stadium',
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ChipShowcase(showOptions: true),
        ),
        ListTileReveal(
          dense: true,
          title: const Text('Known issues'),
          subtitleReveal: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  style: spanTextStyle,
                  text: 'Prior to version 3.13 Flutter Chip theming had severe '
                      'theming limitations and M3 styling gaps. You could not '
                      'make themed Chips where Selected chips required a '
                      'different text '
                      'contrast than the normal Chips. It was not possible to '
                      'define different Chip text styles for such a setup. See '
                      'Flutter SDK ',
                ),
                LinkTextSpan(
                  style: linkStyle,
                  uri: _fcsFlutterIssue115827,
                  text: 'issue #115827',
                ),
                // _fcsChipUmbrellaIssue115364
                TextSpan(
                  style: spanTextStyle,
                  text: '.\n\n'
                      'Fixes have been made in Flutter 3.13 to '
                      'support this, but it is still unverified and not yet '
                      'available in current FCS version. Until it is verified '
                      'and supported, prefer theme colors that work with the '
                      'default Chip text contrast color. '
                      'The Chip has a few other known issues, for a list and '
                      'their status of check the umbrella ',
                ),
                LinkTextSpan(
                  style: linkStyle,
                  uri: _fcsChipUmbrellaIssue115364,
                  text: 'issue #115364',
                ),
                TextSpan(
                  style: spanTextStyle,
                  text: '. Most of them are solved in Flutter 3.13.\n',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
