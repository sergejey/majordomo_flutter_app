import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:home_app/pages/page_settings.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';
import 'package:home_app/config.dart';
import 'package:home_app/utils/logging.dart';
import 'package:localization/localization.dart';

BottomNavigationBar bottomAppBar(context) {
  final stateManager = getIt<MainPageManager>();
  final double inactiveOpacity = 0.4;
  return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: SvgPicture.asset('assets/navigation/nav_favorite.svg',colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .primaryColor.withOpacity(stateManager.bottomBarIndex==0?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'bar_favorites'.i18n(),
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: SvgPicture.asset('assets/navigation/nav_home.svg', colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .primaryColor.withOpacity(stateManager.bottomBarIndex==1?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'bar_home'.i18n(),
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: SvgPicture.asset('assets/navigation/nav_rooms.svg', colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .primaryColor.withOpacity(stateManager.bottomBarIndex==2?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'bar_rooms'.i18n(),
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: SvgPicture.asset('assets/navigation/nav_attention.svg', colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .primaryColor.withOpacity(stateManager.bottomBarIndex==3?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'bar_active'.i18n(),
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: SvgPicture.asset('assets/navigation/nav_settings.svg', colorFilter:
        ColorFilter.mode(Theme
            .of(context)
            .primaryColor.withOpacity(stateManager.bottomBarIndex==4?1:inactiveOpacity), BlendMode.srcIn)),
        label: 'settings'.i18n(),
      ),
    ],
    currentIndex: stateManager.bottomBarIndex,
    selectedItemColor: Theme
        .of(context)
        .primaryColor,
    onTap: (int index) {
      stateManager.setBottomBarIndex(index, context);
    },
  );
  /*
  return Container(
  decoration:
  BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        blurRadius: 20,
        color: Colors.black.withOpacity(.1),
      )
    ],
  )
  ,
  child: SafeArea(
  child: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
  child: GNav(
  rippleColor: Colors.grey[300]!,
  hoverColor: Theme.of(context).primaryColor,
  gap: 8,
  activeColor: Theme.of(context).colorScheme.onPrimary,
  iconSize: 24,
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  duration: Duration(milliseconds: 400),
  tabBackgroundColor: Colors.grey[100]!,
  color: Theme.of(context).primaryColor,
  tabs: [
  GButton(
  icon: Icons.favorite_border_outlined,
  backgroundColor: Theme.of(context).primaryColor,
  //text: 'bar_home'.i18n(),
  ),
  GButton(
  icon: Icons.home_outlined,
  backgroundColor: Theme.of(context).primaryColor,
  //text: 'bar_favorites'.i18n(),
  ),
  GButton(
  icon: Icons.collections_bookmark,
  backgroundColor: Theme.of(context).primaryColor,
  //text: 'bar_rooms'.i18n(),
  ),
  GButton(
  icon: Icons.local_activity_outlined,
  backgroundColor: Theme.of(context).primaryColor,
  //text: 'bar_active'.i18n(),
  ),
  GButton(
  icon: Icons.settings_outlined,
  backgroundColor: Theme.of(context).primaryColor,
  //text: "nav_settings".i18n(),
  ),
  ],
  selectedIndex: stateManager.bottomBarIndex,
  onTabChange: (index) {
  stateManager.setBottomBarIndex(index, context);
  },
  ),
  ),
  ),
  );*/
  }