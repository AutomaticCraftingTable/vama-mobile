import 'package:flutter/material.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/components/subscription_card_factory.dart';

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
                    return SubscriptionCardFactory.create(context, subscriptions[index]);
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
