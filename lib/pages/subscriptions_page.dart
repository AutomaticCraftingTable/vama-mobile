import 'package:flutter/material.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/headers/header.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: ApiService().fetchSubscriptions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Błąd: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Brak subskrypcji.'));
                  }

                  final subscriptions = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = subscriptions[index];
                      return Card(
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
                              backgroundImage: NetworkImage(
                                subscription['author']['logo'] ?? '',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subscription['author']['nickname'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                    );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
