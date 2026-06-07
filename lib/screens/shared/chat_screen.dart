import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                widget.userName,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              // Call User
            },
            icon: const Icon(Icons.call,),
          ),
        ],
      ),
      body: Column(
        children: [
          // MESSAGES
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                receivedMessage(
                  'Hello, I have booked 2 seats.',
                ),

                sentMessage(
                  'Thank you. Your booking has been confirmed.',
                ),

                receivedMessage(
                  'What is the exact pickup location?',
                ),

                sentMessage(
                  'Daewoo Terminal Lahore.',
                ),
              ],
            ),
          ),

          // MESSAGE BOX
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText:
                      'Type a message',
                      border:
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.primary,
                  child: IconButton(onPressed: () {
                      if (messageController.text.trim().isEmpty) {
                        return;
                      }

                      // Send Message API
                      messageController.clear();
                    },

                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sentMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,

      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
          left: 60,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style:
          const TextStyle(color:Colors.white,),
        ),
      ),
    );
  }

  Widget receivedMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 60,),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message),
      ),
    );
  }
}