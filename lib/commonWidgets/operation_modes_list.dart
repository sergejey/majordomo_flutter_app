import 'package:flutter/material.dart';
import '../models/operational_mode.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_modes.dart';
import 'package:home_app/pages/page_settings.dart';
import 'package:home_app/pages/page_main_logic.dart';

class OperationalModesList extends StatelessWidget {
  const OperationalModesList({super.key, required this.modes});

  final List<OperationalMode> modes;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffb9cbe8).withOpacity(0.6),
                blurRadius: 5,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: modes.length == 0
                ? const Icon(Icons.link_off, color: Colors.grey)
                : Wrap(
                    spacing: 0,
                    children: List.generate(modes.length, (index) {
                      Icon modeIcon = Icon(Icons.question_mark,
                          color: Theme.of(context).colorScheme.secondary);
                      if (modes[index].object == 'EconomMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.eco,
                                color: Theme.of(context).primaryColor)
                            : Icon(Icons.eco_outlined,
                                color: Theme.of(context).colorScheme.secondary);
                      } else if (modes[index].object == 'NobodyHomeMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.person_off_outlined,
                                color: Colors.green)
                            : Icon(Icons.person,
                                color: Theme.of(context).colorScheme.secondary);
                      } else if (modes[index].object == 'SecurityArmedMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.security,
                                color: Theme.of(context).primaryColor)
                            : Icon(Icons.security,
                                color: Theme.of(context).colorScheme.secondary);
                      } else if (modes[index].object == 'GuestsMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.people_outline,
                                color: Theme.of(context).primaryColor)
                            : Icon(Icons.people_outline,
                                color: Theme.of(context).colorScheme.secondary);
                      } else if (modes[index].object == 'DarknessMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.nightlight,
                                color: Theme.of(context).primaryColor)
                            : Icon(Icons.sunny,
                                color: Theme.of(context).colorScheme.secondary);
                      } else if (modes[index].object == 'NightMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.bed,
                                color: Theme.of(context).primaryColor)
                            : Icon(Icons.bed,
                                color: Theme.of(context).colorScheme.secondary);
                      } else if (modes[index].object == 'connectionLocal') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.wifi,
                                color: Theme.of(context).primaryColor)
                            : Icon(Icons.wifi,
                                color: Theme.of(context).colorScheme.secondary);
                      } else if (modes[index].object == 'connectionRemote') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.network_cell,
                                color: Theme.of(context).primaryColor)
                            : Icon(Icons.network_cell,
                                color: Theme.of(context).colorScheme.secondary);
                      }
                      return GestureDetector(
                          onTap: () {
                            final stateManager = getIt<MainPageManager>();
                            stateManager.endPeriodicUpdate();
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => modes.length == 0
                                    ? PageSettings()
                                    : PageModes(
                                        initialTab: 0,
                                      ),
                              ),
                            )
                                .then((value) {
                              stateManager.reload();
                            });
                          },
                          child: modeIcon);
                    })),
          ),
        ));
  }
}
