import 'package:flutter/material.dart';

class QuickActionsWidget extends StatefulWidget {
  const QuickActionsWidget({super.key});

  @override
  State<QuickActionsWidget> createState() => _QuickActionsWidgetState();
}

class _QuickActionsWidgetState extends State<QuickActionsWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {'icon': Icons.card_giftcard, 'label': 'Rewards'},
      {'icon': Icons.people_alt_outlined, 'label': 'Referral'},
      {'icon': Icons.savings_outlined, 'label': 'Earn'},
      {'icon': Icons.smart_toy_outlined, 'label': 'Trading bots'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((action) {
          return Column(
            children: [
              Icon(action['icon'], size: 28),
              const SizedBox(height: 8),
              Text(action['label'], style: const TextStyle(fontSize: 12)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
