import 'dart:async';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:home_app/models/chat_message.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';
import 'package:home_app/utils/logging.dart';

class PageChatNotifier extends ValueNotifier<String> {
  PageChatNotifier() : super('');
  final _dataService = getIt<DataService>();

  List<types.Message> chatMessages = [];
  List<ChatMessage> myMessages = [];

  ChatUser myUser = ChatUser(id: "1", name: "Admin");

  types.User chatControlUser =
      types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ad');

  void addMessage(types.TextMessage message) async {
    chatMessages.insert(0, message);
    refreshChat();
    if (await _dataService.postMessage(message.text) ?? false) {
      fetchMessages();
    }
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: chatControlUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );
    addMessage(textMessage);
  }

  Future<void> initialize() async {
    await _dataService.initialize();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    var (messagesReturned, userReturned) = await _dataService.fetchMessages();

    if (messagesReturned.length==0) return;

    myMessages = messagesReturned;
    myUser = userReturned;

    chatControlUser = types.User(id: myUser.id, firstName: myUser.name);

    chatMessages = myMessages.map<types.Message>((msg) {
      return types.TextMessage(
          author: types.User(id: msg.user_id, firstName: msg.user_name),
          createdAt: msg.added.millisecondsSinceEpoch,
          text: msg.message,
          id: msg.id);
    }).toList();
    chatMessages.sort((a, b) => a.createdAt?.compareTo(b.createdAt ?? 0) ?? 0);
    chatMessages = chatMessages.reversed.toList();
    refreshChat();
  }

  refreshChat() {
    _updateChatPage(DateTime.now().millisecondsSinceEpoch.toString());
  }

  void _updateChatPage(String newValue) {
    value = newValue;
  }


}

