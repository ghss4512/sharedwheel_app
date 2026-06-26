import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/conversation_model.dart';
import '../../services/message_service.dart';
import '../../utils/app_session.dart';
import '../../widgets/loading_widget.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final MessageService messageService = MessageService();

  bool isLoading = true;

  List<ConversationModel> conversations = [];

  @override
  void initState() {
    super.initState();
    loadConversations();
  }

  Future<void> loadConversations() async {
    if (AppSession.userId == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      conversations = await messageService.getConversations(
        userId: AppSession.userId!,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Widget buildConversationCard(ConversationModel conversation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: conversation.profilePhoto.isNotEmpty
              ? NetworkImage(conversation.profilePhoto)
              : null,
          child: conversation.profilePhoto.isEmpty
              ? const Icon(Icons.person)
              : null,
        ),

        title: Text(
          conversation.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              conversation.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            Text(conversation.createdAt, style: const TextStyle(fontSize: 12)),
          ],
        ),

        trailing: conversation.unreadCount > 0
            ? CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary,
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : null,

        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                rideId: conversation.rideId,
                otherUserId: conversation.otherUserId,
                otherUserName: conversation.fullName,
              ),
            ),
          );

          loadConversations();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const LoadingWidget()
          : conversations.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),

                  SizedBox(height: 10),

                  Text('No conversations found'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadConversations,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  return buildConversationCard(conversations[index]);
                },
              ),
            ),
    );
  }
}
