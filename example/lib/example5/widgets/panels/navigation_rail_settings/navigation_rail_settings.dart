import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../../../shared/controllers/theme_controller.dart';
import '../../../../shared/widgets/universal/navigation_rail_label_type_buttons.dart';
import '../../../../shared/widgets/universal/switch_list_tile_adaptive.dart';
import '../../../../shared/widgets/universal/theme_showcase.dart';
import '../../shared/color_scheme_popup_menu.dart';

class NavigationRailSettings extends StatelessWidget {
  const NavigationRailSettings(this.controller, {Key? key}) : super(key: key);
  final ThemeController controller;

  String explainLabelStyle(final NavigationRailLabelType labelStyle) {
    switch (labelStyle) {
      case NavigationRailLabelType.none:
        return 'Items have no labels';
      case NavigationRailLabelType.selected:
        return 'Only selected item has a label';
      case NavigationRailLabelType.all:
        return 'All items have labels';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String labelForDefaultIndicator = (!controller.useFlexColorScheme ||
            (controller.useFlutterDefaults &&
                controller.navRailIndicatorSchemeColor == null))
        ? 'null (secondary)'
        : 'null (primary)';
    const String labelForDefaultSelectedItem = 'null (primary)';
    // (!controller.useFlexColorScheme ||
    //         (controller.useFlutterDefaults &&
    //             controller.navRailSelectedSchemeColor == null &&
    //             controller.navRailUnselectedSchemeColor == null))
    //     ? 'null (primary)'
    //     : 'null (primary)';
    final bool muteUnselectedEnabled = controller.useSubThemes &&
        controller.useFlexColorScheme &&
        !(controller.useFlutterDefaults &&
            controller.navRailSelectedSchemeColor == null &&
            controller.navRailUnselectedSchemeColor == null);
    final String labelForDefaultUnelectedItem =
        (!controller.useFlexColorScheme ||
                !controller.useSubThemes ||
                (controller.useFlutterDefaults &&
                    controller.navRailSelectedSchemeColor == null &&
                    controller.navRailUnselectedSchemeColor == null))
            ? 'null (onSurface with opacity)'
            : controller.navRailMuteUnselected && muteUnselectedEnabled
                ? 'null (onSurface, blend & opacity)'
                : 'null (onSurface)';
    final bool navRailOpacityEnabled = controller.useSubThemes &&
        controller.useFlexColorScheme &&
        !(controller.navRailBackgroundSchemeColor == null &&
            controller.useFlutterDefaults);
    final double navRailOpacity =
        navRailOpacityEnabled ? controller.navRailOpacity : 1;

    final double navRailElevation =
        controller.useSubThemes && controller.useFlexColorScheme
            ? controller.navigationRailElevation
            : 8;
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        ColorSchemePopupMenu(
          title: const Text('Background color'),
          labelForDefault: !controller.useSubThemes ||
                  !controller.useFlexColorScheme ||
                  (controller.useFlutterDefaults &&
                      controller.navRailBackgroundSchemeColor == null)
              ? 'null (surface)'
              : 'null (background)',
          index: controller.navRailBackgroundSchemeColor?.index ?? -1,
          onChanged: controller.useSubThemes && controller.useFlexColorScheme
              ? (int index) {
                  if (index < 0 || index >= SchemeColor.values.length) {
                    controller.setNavRailBackgroundSchemeColor(null);
                  } else {
                    controller.setNavRailBackgroundSchemeColor(
                        SchemeColor.values[index]);
                  }
                }
              : null,
        ),
        ListTile(
          enabled: navRailOpacityEnabled,
          title: const Text('Background opacity'),
          subtitle: Slider.adaptive(
            max: 100,
            divisions: 100,
            label: (navRailOpacity * 100).toStringAsFixed(0),
            value: navRailOpacity * 100,
            onChanged: navRailOpacityEnabled
                ? (double value) {
                    controller.setNavRailOpacity(value / 100);
                  }
                : null,
          ),
          trailing: Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'OPACITY',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  // ignore: lines_longer_than_80_chars
                  '${(navRailOpacity * 100).toStringAsFixed(0)} %',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        // const Divider(),
        ListTile(
          title: const Text('Elevation'),
          subtitle: Slider.adaptive(
            max: 24,
            divisions: 48,
            label: navRailElevation.toStringAsFixed(1),
            value: navRailElevation,
            onChanged: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.setNavigationRailElevation
                : null,
          ),
          trailing: Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'ELEV',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  navRailElevation.toStringAsFixed(1),
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SwitchListTileAdaptive(
          title: const Text('Use selection indicator'),
          subtitle: const Text('Also ON when ThemeData.useMaterial3 '
              'is true, turn OFF sub-themes and try it'),
          value: controller.navRailUseIndicator &&
              controller.useSubThemes &&
              controller.useFlexColorScheme,
          onChanged: controller.useSubThemes && controller.useFlexColorScheme
              ? controller.setNavRailUseIndicator
              : null,
        ),
        ColorSchemePopupMenu(
          title: const Text('Selection indicator color'),
          labelForDefault: labelForDefaultIndicator,
          index: controller.navRailIndicatorSchemeColor?.index ?? -1,
          onChanged: controller.navRailUseIndicator &&
                  controller.useSubThemes &&
                  controller.useFlexColorScheme
              ? (int index) {
                  if (index < 0 || index >= SchemeColor.values.length) {
                    controller.setNavRailIndicatorSchemeColor(null);
                  } else {
                    controller.setNavRailIndicatorSchemeColor(
                        SchemeColor.values[index]);
                  }
                }
              : null,
        ),
        ListTile(
          enabled: controller.useSubThemes && controller.useFlexColorScheme,
          title: const Text('Labels when rail is collapsed'),
          subtitle: Text(explainLabelStyle(
              controller.useSubThemes && controller.useFlexColorScheme
                  ? controller.navRailLabelType
                  : NavigationRailLabelType.none)),
          trailing: NavigationRailLabelTypeButtons(
            style: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.navRailLabelType
                : NavigationRailLabelType.none,
            onChanged: controller.useSubThemes && controller.useFlexColorScheme
                ? controller.setNavRailLabelType
                : null,
          ),
        ),
        NavigationRailShowcase(
          height: 650,
          // TODO(rydmike): Still needed? Sometimes worked without it, weird.
          // This is used as a work around to avoid unnecessarily eager
          // assert in SDK.
          // Assertion: line 562: 'useIndicator || indicatorColor == null'
          // A flag is used to do trickery with transparency for this
          // assertion that we cannot avoid since the theme controls the
          // setup and user it. User may enter combo that has no effect, and
          // triggers the assert.
          // It should be obvious that if you have no indicator color
          // you cannot use an indicator, why assert it? Just don't show one!
          useAssertWorkAround:
              (!controller.useSubThemes || !controller.useFlexColorScheme) &&
                  !controller.useMaterial3,
          child: Column(
            children: <Widget>[
              ColorSchemePopupMenu(
                title: const Text('Selected item color'),
                subtitle:
                    const Text('Label and icon, but own properties in API'),
                labelForDefault: labelForDefaultSelectedItem,
                index: controller.navRailSelectedSchemeColor?.index ?? -1,
                onChanged: controller.useSubThemes &&
                        controller.useFlexColorScheme
                    ? (int index) {
                        if (index < 0 || index >= SchemeColor.values.length) {
                          controller.setNavRailSelectedSchemeColor(null);
                        } else {
                          controller.setNavRailSelectedSchemeColor(
                              SchemeColor.values[index]);
                        }
                      }
                    : null,
              ),
              ColorSchemePopupMenu(
                title: const Text('Unselected item color'),
                subtitle:
                    const Text('Label and icon, but own properties in API'),
                labelForDefault: labelForDefaultUnelectedItem,
                index: controller.navRailUnselectedSchemeColor?.index ?? -1,
                onChanged: controller.useSubThemes &&
                        controller.useFlexColorScheme
                    ? (int index) {
                        if (index < 0 || index >= SchemeColor.values.length) {
                          controller.setNavRailUnselectedSchemeColor(null);
                        } else {
                          controller.setNavRailUnselectedSchemeColor(
                              SchemeColor.values[index]);
                        }
                      }
                    : null,
              ),
              SwitchListTileAdaptive(
                title: const Text('Mute unselected items'),
                subtitle: const Text(
                    'Unselected icon and text are less bright. Shared '
                    'setting for icon and text, but separate properties '
                    'in API'),
                value: muteUnselectedEnabled
                    ? controller.navRailMuteUnselected
                    : !muteUnselectedEnabled,
                onChanged: muteUnselectedEnabled
                    ? controller.setNavRailMuteUnselected
                    : null,
              ),
              const Divider(height: 16),
              SwitchListTileAdaptive(
                title: const Text('Use Flutter defaults'),
                subtitle: const Text('Undefined values will fall back to '
                    'Flutter SDK defaults. Prefer OFF to use FCS defaults. '
                    'Here, both selected and unselected color have to be null '
                    'before the item colors can fall back to Flutter defaults. '
                    'This setting affects many component themes that implement '
                    'it. It is included on panels where it has an impact. '
                    'See API docs for more info.'),
                value: controller.useFlutterDefaults &&
                    controller.useSubThemes &&
                    controller.useFlexColorScheme,
                onChanged:
                    controller.useSubThemes && controller.useFlexColorScheme
                        ? controller.setUseFlutterDefaults
                        : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
