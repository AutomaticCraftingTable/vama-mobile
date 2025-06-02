import 'package:flutter/material.dart';

class SubscriptionCardFactory {
  static Widget create(BuildContext context, Map<String, dynamic> subscription) {
    final accountId = subscription['author']['account_id'];

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/profile',
          arguments: accountId,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(subscription['author']['logo'] ?? ''),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription['author']['nickname'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subscription['author']['description'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
