import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;
  final bool isEditing;
  final VoidCallback? onCancelEdit;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
    this.isEditing = false,
    this.onCancelEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isEditing)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined,
                      size: 16, color: AppColors.primaryTeal),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text('Editing message',
                        style: TextStyle(
                            color: AppColors.primaryTeal, fontSize: 12)),
                  ),
                  GestureDetector(
                    onTap: onCancelEdit,
                    child: const Icon(Icons.close,
                        size: 16, color: AppColors.slate),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText:
                          isEditing ? 'Edit your message' : 'Type a message',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: AppColors.primaryTeal,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: isSending ? null : onSend,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(
                              isEditing
                                  ? Icons.check_rounded
                                  : Icons.send_rounded,
                              color: Colors.white,
                              size: 20),
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
}
