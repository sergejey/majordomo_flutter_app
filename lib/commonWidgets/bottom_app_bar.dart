import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';
import 'package:localization/localization.dart';

BottomNavigationBar bottomAppBar(context) {
  final stateManager = getIt<MainPageManager>();
  final double inactiveOpacity = 0.4;
  return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: SvgPicture.asset('assets/navigation/nav_favorite.svg',colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .colorScheme.onPrimary.withOpacity(stateManager.bottomBarIndex==0?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'bar_favorites'.i18n(),
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: SvgPicture.asset('assets/navigation/nav_home.svg', colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .colorScheme.onPrimary.withOpacity(stateManager.bottomBarIndex==1?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'bar_home'.i18n(),
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: SvgPicture.asset('assets/navigation/nav_rooms.svg', colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .colorScheme.onPrimary.withOpacity(stateManager.bottomBarIndex==2?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'bar_rooms'.i18n(),
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: SvgPicture.asset('assets/navigation/nav_attention.svg', colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .colorScheme.onPrimary.withOpacity(stateManager.bottomBarIndex==3?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'bar_active'.i18n(),
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: SvgPicture.asset('assets/navigation/nav_settings.svg', colorFilter:
        ColorFilter.mode(Theme
            .of(context).colorScheme.onPrimary.withOpacity(stateManager.bottomBarIndex==4?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'settings'.i18n(),
      ),
    ],
    currentIndex: stateManager.bottomBarIndex,
    selectedItemColor: Theme
        .of(context)
        .colorScheme.tertiary,
    onTap: (int index) {
      stateManager.setBottomBarIndex(index, context);
    },
  );
  }