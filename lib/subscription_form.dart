import 'package:flutter/material.dart';
import 'package:subscription_tracker/subscription.dart';
import 'package:currency_picker/currency_picker.dart';

class SubscriptionForm extends StatefulWidget {
  final void Function(Subscription) callback;
  final Subscription subscription;

  SubscriptionForm(Subscription? subscription, this.callback, {super.key})
      : subscription =
            (subscription == null) ? Subscription.newEmpty() : subscription;

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  late Currency currency;
  TextEditingController startDateController = TextEditingController();
  late Renewal renewal;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.subscription.title;
    descriptionController.text = widget.subscription.description;
    amountController.text = widget.subscription.amount;
    currency = widget.subscription.currency;
    startDateController.text = widget.subscription.startDate.toString();
    renewal = widget.subscription.renewalPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 30,
              decoration: const InputDecoration(
                labelText: "Title *",
                hintText: "What service is this subscription for?",
              ),
              controller: titleController,
              onFieldSubmitted: (value) => titleController.text = value,
              validator: (value) => (value == null || value == '')
                  ? 'Title cannot be empty'
                  : null,
            ),
            TextFormField(
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Any details you'd like to take note of",
              ),
              controller: descriptionController,
              onFieldSubmitted: (value) => descriptionController.text = value,
            ),
            TextFormField(
              maxLength: 20,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Amount",
                hintText: "0.0",
              ),
              controller: amountController,
              onFieldSubmitted: (value) => amountController.text = value,
            ),
            MaterialButton(
              child: Text("${currency.code}  ${currency.symbol}"),
              onPressed: () => showCurrencyPicker(
                  context: context, onSelect: (value) => setState(() => {currency = value})),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.callback(getSubscription());
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

  Subscription getSubscription() {
    return Subscription(
      key: widget.subscription.key,
      title: titleController.text,
      description: descriptionController.text,
      amount: amountController.text,
      currency: currency,
      startDate: DateTime.parse(startDateController.text),
      renewalPeriod: renewal,
    );
  }
}
