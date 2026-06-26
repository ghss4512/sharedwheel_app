import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/message_model.dart';
import '../../services/message_service.dart';
import '../../utils/app_session.dart';
import '../../utils/functions.dart';

class ChatScreen extends StatefulWidget {
  final int rideId;
  final int otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.rideId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageService messageService = MessageService();

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  List<MessageModel> messages = [];

  bool isLoading = true;
  bool isSending = false;

  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    loadMessages();

    refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => loadMessages(showLoader: false),
    );
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadMessages({bool showLoader = true}) async {
    if (AppSession.userId == null) {
      return;
    }

    if (showLoader) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final result = await messageService.getConversation(
        rideId: widget.rideId,
        userId: AppSession.userId!,
        otherUserId: widget.otherUserId,
      );

      messages = result;

      if (mounted) {
        setState(() {});
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    if (showLoader) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendMessage() async {
    if (AppSession.userId == null) {
      return;
    }

    final text = messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      final response = await messageService.sendMessage(
        rideId: widget.rideId,
        senderId: AppSession.userId!,
        receiverId: widget.otherUserId,
        message: text,
      );

      if (response['success'] == true) {
        messageController.clear();

        await loadMessages(showLoader: false);
      } else {
        if (mounted) {
          Functions.error(context, response['message']);
        }
      }
    } catch (e) {
      if (mounted) {
        Functions.error(context, 'Unable to send message.');
      }
    }

    if (!mounted) return;

    setState(() {
      isSending = false;
    });
  }

  Widget buildMessageBubble(MessageModel message) {
    final isMine = message.senderId == AppSession.userId;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(color: isMine ? Colors.white : Colors.black),
            ),

            const SizedBox(height: 4),

            Text(
              message.createdAt,
              style: TextStyle(
                fontSize: 10,
                color: isMine ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) {
                  sendMessage();
                },
              ),
            ),

            const SizedBox(width: 8),

            IconButton(
              onPressed: isSending ? null : sendMessage,
              icon: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: Text(widget.otherUserName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? const Center(child: Text('No messages yet'))
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return buildMessageBubble(messages[index]);
                    },
                  ),
          ),

          buildInputArea(),
        ],
      ),
    );
  }
}
