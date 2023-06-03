import 'package:flutter/material.dart';

import '../widgets/no_content_view.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoContent(
      description: 'You don’t have any order history, yet',
      explanation: 'Order history will appear here once you complete one',
      icon: Icons.watch_later_outlined,
    );
  }
}
