import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Messages',),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          chatCard(
            context: context,
            name: 'Ali Raza',
            lastMessage:
            'I will reach the pickup point in 10 minutes.',
            time: '10:30 AM',
            unreadCount: 2,
          ),

          chatCard(
            context: context,
            name: 'Ahmed Khan',
            lastMessage:
            'Your booking has been confirmed.',
            time: 'Yesterday',
            unreadCount: 0,
          ),

          chatCard(
            context: context,
            name: 'Usman Ali',
            lastMessage:
            'Please share your exact pickup location.',
            time: 'Yesterday',
            unreadCount: 1,
          ),
        ],
      ),
    );
  }

  Widget chatCard({
    required BuildContext context,
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          AppColors.primary.withAlpha(38),
          child: const Icon(
            Icons.person,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            if (unreadCount > 0)
              CircleAvatar(
                radius: 10,
                backgroundColor:
                AppColors.danger,
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(userName: name,),
            ),

          );

        },
      ),
    );
  }
}