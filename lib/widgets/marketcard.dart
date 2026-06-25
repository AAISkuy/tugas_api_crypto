import 'package:flutter/material.dart';

class MarketCardsWidget extends StatefulWidget {
  const MarketCardsWidget({super.key});

  @override
  State<MarketCardsWidget> createState() => _MarketCardsWidgetState();
}

class _MarketCardsWidgetState extends State<MarketCardsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _MiniCard(title: 'BTC', subtitle: 'Crypto', price: '61,891.36', change: '-1.33%', isUp: false),
          _MiniCard(title: 'RSPCX', subtitle: 'Stock', price: '155.57', change: '-0.94%', isUp: false),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessElement {
  final String title, subtitle, price, change;
  final bool isUp;

  const _MiniCard({
    required this.title, required this.subtitle, 
    required this.price, required this.change, required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 22,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              Icon(Icons.show_chart, color: isUp ? Colors.teal : Colors.pinkAccent, size: 16)
            ],
          ),
          const SizedBox(height: 12),
          Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(change, style: TextStyle(fontSize: 12, color: isUp ? Colors.teal : Colors.pinkAccent)),
        ],
      ),
    );
  }
}