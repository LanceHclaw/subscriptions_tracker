import 'package:flutter/material.dart';
//import 'package:subscription_tracker/subscription.dart';

class SubscriptionForm extends StatefulWidget {
  const SubscriptionForm({super.key});

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  //Subscription subscription;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const TextField(
              maxLength: 30,
              decoration: InputDecoration(
                labelText: "Title *",
                hintText: "What service is this subscription for?",
              ),
            ),
            TextFormField(
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Any details you'd like to take note of",
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Saved"),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
