import 'package:flutter/material.dart';

import '../../../../shared/controllers/theme_controller.dart';
import '../../../../shared/model/adaptive_theme.dart';
import '../../../../shared/model/splash_type_enum.dart';
import '../../../../shared/model/visual_density_enum.dart';
import '../../../../shared/widgets/universal/list_tile_reveal.dart';
import '../../shared/back_to_actual_platform.dart';
import '../../shared/enum_popup_menu.dart';
import '../../shared/is_web_list_tile.dart';
import '../../shared/platform_popup_menu.dart';
import '../../shared/visual_density_popup_menu.dart';

// Panel used to control the adaptive theme settings.
class AdaptiveThemeSettings extends StatelessWidget {
  const AdaptiveThemeSettings(this.controller, {super.key});
  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;

    // The most common logic for enabling Playground controls.
    final bool enableControl =
        controller.useSubThemes && controller.useFlexColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        const ListTileReveal(
          title: Text('Platform adaptive behavior'),
          subtitleReveal: Text(
              'With platform adaptive settings you can modify theme '
              'properties to have a different response on selected platforms. '
              'You can select which platforms the platform adaptive value '
              'should be used on. All other platforms not included '
              'in this choice, will continue to use the none adaptive '
              'value or default behavior.\n'
              '\n'
              'Using the API you can customize which platform an adaptive '
              'feature is used on, including separate definitions when using '
              'the app in a web build on each platform. The selections here '
              'use built-in combinations, they cover most use cases.'),
        ),
        VisualDensityPopupMenu(
          title: const Text('VisualDensity'),
          subtitle: const Text(
            'Defines the visual density of user interface components. '
            'Density, in the context of a UI, is the vertical and horizontal '
            '"compactness" of the components in the UI. It is without unit, '
            'since it means different things to different UI components.\n',
          ),
          index: controller.usedVisualDensity?.index ?? -1,
          onChanged: controller.useFlexColorScheme
              ? (int index) {
                  if (index < 0 || index >= VisualDensityEnum.values.length) {
                    controller.setUsedVisualDensity(null);
                  } else {
                    controller
                        .setUsedVisualDensity(VisualDensityEnum.values[index]);
                  }
                }
              : null,
        ),
        const Divider(),
        EnumPopupMenu<SplashTypeEnum>(
          enabled: enableControl,
          values: SplashTypeEnum.values,
          title: const Text('Splash type'),
          subtitleReveal: Text(
            'Defines the type of tap ink splash effect used on Material '
            'UI components.\n'
            '\n'
            // ignore: lines_longer_than_80_chars
            '${controller.splashType?.describe ?? SplashTypeEnum.defaultSplash.describe}',
          ),
          value: controller.splashType,
          onChanged: controller.setSplashType,
        ),
        EnumPopupMenu<AdaptiveTheme>(
          enabled: enableControl,
          values: AdaptiveTheme.values,
          title: const Text('Use adaptive splash'),
          subtitleReveal: Text(
            'An adaptive theme response used to select a different ink '
            'splash effect on selected platforms.\n'
            '\n'
            // ignore: lines_longer_than_80_chars
            '${controller.adaptiveSplash?.describe ?? AdaptiveTheme.off.describe}',
          ),
          value: controller.adaptiveSplash,
          onChanged: controller.setAdaptiveSplash,
        ),
        EnumPopupMenu<SplashTypeEnum>(
          enabled: enableControl &&
              controller.adaptiveSplash != AdaptiveTheme.off &&
              controller.adaptiveSplash != null,
          values: SplashTypeEnum.values,
          title: const Text('Adaptive splash'),
          subtitleReveal: Text(
            'Defines the type of tap ink splash effect response used on '
            'Material UI components when running on selected platforms. When '
            'not running on these platforms or if the platform adaptive ink '
            'feature is OFF, the ink splash effect above is used.\n'
            '\n'
            // ignore: lines_longer_than_80_chars
            '${controller.splashTypeAdaptive?.describe ?? SplashTypeEnum.defaultSplash.describe}',
          ),
          value: controller.splashTypeAdaptive,
          onChanged: controller.setSplashTypeAdaptive,
        ),
        const Divider(),
        if (isLight) ...<Widget>[
          EnumPopupMenu<AdaptiveTheme>(
            enabled: enableControl && controller.useMaterial3,
            values: AdaptiveTheme.values,
            title: const Text('Bring elevation shadows back'),
            subtitleReveal: Text(
              'An adaptive theme response to bring elevation shadows back in '
              'Material-3 in light theme mode on selected platforms. '
              'Has no impact in Material-2 mode. '
              'Applies to AppBar, BottomAppBar, BottomSheet, DatePickerDialog, '
              'Dialog, Drawer, NavigationBar, NavigationDrawer.\n'
              '\n'
              // ignore: lines_longer_than_80_chars
              '${controller.adaptiveElevationShadowsBackLight?.describe ?? AdaptiveTheme.off.describe}',
            ),
            value: controller.adaptiveElevationShadowsBackLight,
            onChanged: controller.setAdaptiveElevationShadowsBackLight,
          ),
          EnumPopupMenu<AdaptiveTheme>(
            enabled: enableControl && controller.useMaterial3,
            values: AdaptiveTheme.values,
            title: const Text('Remove elevation tint'),
            subtitleReveal: Text(
              'An adaptive theme response to remove elevation tint on elevated '
              'surfaces in Material-3 in dark theme mode on selected '
              'platforms. This is not recommended in dark mode, unless '
              'shadows are also brought back in Flutter prior to version 3.22. '
              'However, even then it is bad '
              'idea since shadows are not very visible in dark mode. Recommend '
              'keeping elevation tint in M3 mode in dark mode in Flutter '
              'versions before to 3.22. You can '
              'still bring shadows back in dark mode, it can further increase '
              'elevation separation in dark mode.\n'
              '\n'
              'In Flutter version 3.22 and later this feature is not needed, '
              'since elevation tints are removed by default. '
              'This setting also has no impact in Material-2 mode.\n'
              '\n'
              'Feature applies to BottomAppBar, BottomSheet, Card, Chip, '
              'DatePickerDialog, Dialog, Drawer, DropdownMenu, MenuBar, '
              'MenuAnchor, NavigationDrawer and PopupMenuButton. There is a '
              'separate tint removal setting for the NavigationBar, as you may '
              'want to keep it on even if otherwise removing tint.\n'
              '\n'
              // ignore: lines_longer_than_80_chars
              '${controller.adaptiveRemoveElevationTintLight?.describe ?? AdaptiveTheme.off.describe}',
            ),
            value: controller.adaptiveRemoveElevationTintLight,
            onChanged: controller.setAdaptiveRemoveElevationTintLight,
          ),
        ] else ...<Widget>[
          EnumPopupMenu<AdaptiveTheme>(
            enabled: enableControl && controller.useMaterial3,
            values: AdaptiveTheme.values,
            title: const Text('Bring elevation shadows back'),
            subtitleReveal: Text(
              'An adaptive theme response to bring elevation shadows back in '
              'Material-3 in dark theme mode on selected platforms. '
              'Has no impact in Material-2 mode. '
              'Applies to AppBar, BottomAppBar, BottomSheet, DatePickerDialog, '
              'Dialog, Drawer, NavigationBar, NavigationDrawer.\n'
              '\n'
              // ignore: lines_longer_than_80_chars
              '${controller.adaptiveElevationShadowsBackDark?.describe ?? AdaptiveTheme.off.describe}',
            ),
            value: controller.adaptiveElevationShadowsBackDark,
            onChanged: controller.setAdaptiveElevationShadowsBackDark,
          ),
          EnumPopupMenu<AdaptiveTheme>(
            enabled: enableControl && controller.useMaterial3,
            values: AdaptiveTheme.values,
            title: const Text('Remove elevation tint ENUM'),
            subtitleReveal: Text(
              'An adaptive theme response to remove elevation tint on elevated '
              'surfaces in Material-3 in dark theme mode on selected '
              'platforms. This is not recommended in dark mode, unless '
              'shadows are also brought back in Flutter prior to version 3.22. '
              'However, even then it is bad '
              'idea since shadows are not very visible in dark mode. Recommend '
              'keeping elevation tint in M3 mode in dark mode in Flutter '
              'versions before to 3.22. You can '
              'still bring shadows back in dark mode, it can further increase '
              'elevation separation in dark mode.\n'
              '\n'
              'In Flutter version 3.22 and later this feature is not needed, '
              'since elevation tints are removed by default. '
              'This setting also has no impact in Material-2 mode.\n'
              '\n'
              'Feature applies to BottomAppBar, BottomSheet, Card, Chip, '
              'DatePickerDialog, Dialog, Drawer, DropdownMenu, MenuBar, '
              'MenuAnchor, NavigationDrawer and PopupMenuButton. There is a '
              'separate tint removal setting for the NavigationBar, as you may '
              'want to keep it on even if otherwise removing tint.\n'
              '\n'
              // ignore: lines_longer_than_80_chars
              '${controller.adaptiveRemoveElevationTintLight?.describe ?? AdaptiveTheme.off.describe}',
            ),
            value: controller.adaptiveRemoveElevationTintDark,
            onChanged: controller.setAdaptiveRemoveElevationTintDark,
          ),
        ],
        const Divider(),
        PlatformPopupMenu(
          platform: controller.platform,
          onChanged: controller.setPlatform,
        ),
        IsWebListTile(controller: controller),
        BackToActualPlatform(controller: controller),
        const ListTile(
            dense: true,
            title: Text('You can find additional platform adaptive '
                'theme settings under Shape Radius, Switch, AppBar, '
                'NavigationBar and Dialogs.'))
      ],
    );
  }
}
