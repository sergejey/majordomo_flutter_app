import 'package:flutter/material.dart';
import 'package:home_app/pages/page_chat_logic.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:localization/localization.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';


class PageChat extends StatefulWidget {
  const PageChat({super.key});

  @override
  State<PageChat> createState() => _ChatPageState();
}


class _ChatPageState extends State<PageChat> {
  final stateManager = getIt<ChatPageManager>();

  @override
  void initState() {
    stateManager.initChatPageState();
    super.initState();
  }

  @override
  void deactivate() {
    stateManager.endPeriodicUpdate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<ChatPageManager>();

    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageChatNotifier,
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text('chat'.i18n()),
                actions: [],
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0 ,16,16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffb9cbe8).withOpacity(0.6),
                          blurRadius: 11,
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Chat(
                        l10n: ChatL10nEn(
                          inputPlaceholder: 'chat_placeholder'.i18n(),
                        ),
                      messages: stateManager.pageChatNotifier.chatMessages,
                      onSendPressed: stateManager.pageChatNotifier.handleSendPressed,
                      user: stateManager.pageChatNotifier.chatControlUser,
                      showUserNames: true,
                      theme: DefaultChatTheme(
                        inputBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        inputTextColor: Theme.of(context).primaryColor
                      )
                    )
                  ),
                ),
              ));
        });
  }

}
