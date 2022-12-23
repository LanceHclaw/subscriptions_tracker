import 'package:flutter/material.dart';
import 'package:subscription_tracker/subscription.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:intl/intl.dart';

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
  late DateTime startDate;
  TextEditingController frequencyController = TextEditingController();
  TextEditingController timePeriodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.subscription.title;
    descriptionController.text = widget.subscription.description;
    amountController.text = widget.subscription.amount;
    currency = widget.subscription.currency;
    startDate = widget.subscription.startDate;
    frequencyController.text = widget.subscription.renewalPeriod.every.toString();
    timePeriodController.text = widget.subscription.renewalPeriod.timePeriod.name;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Subscription"),
      ),
      body: SingleChildScrollView(
        child: Form(
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
              amountFields(context),
              dateSelector(context),
              renewalPeriodSelector(context),
              TextFormField(
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "Any details you'd like to take note of",
                ),
                controller: descriptionController,
                onFieldSubmitted: (value) => descriptionController.text = value,
              ),
              exitButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField dateSelector(BuildContext context) {
    final formatter = DateFormat.yMMMd("en_US");
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: formatter.format(startDate),
        hintText: "Select the start of your subscription",
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(3000),
        );
        if (date != null) {
          setState(() {
            startDate = date;
          });
        }
      },
    );
  }

  Column renewalPeriodSelector(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        const Text("Select renewal period"),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text("repeats every"),
                  TextFormField(
                    textAlign: TextAlign.right,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    decoration: InputDecoration(
                      hintText: frequencyController.text,
                    ),
                    onChanged: (value) =>
                        setState(() => frequencyController.text = value),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  const Text("period"),
                  DropdownButtonFormField(
                    value: timePeriodController.text,
                    items: TimePeriod.values
                        .map((e) => getItemFromTimePeriod(e))
                        .toList(),
                    onChanged: ((value) => {timePeriodController.text = value}),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ),
      ],
    );
  }

  DropdownMenuItem getItemFromTimePeriod(TimePeriod period) {
    return DropdownMenuItem(
      value: period.name,
      child: Text(
        period.name,
      ),
    );
  }

  Row exitButtons(BuildContext context) {
    return Row(
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
    );
  }

  Row amountFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            maxLength: 20,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Amount",
              hintText: "0.0",
            ),
            controller: amountController,
            onFieldSubmitted: (value) => amountController.text = value,
          ),
        ),
        MaterialButton(
          child: Text("${currency.code}  ${currency.symbol}"),
          onPressed: () => showCurrencyPicker(
              context: context,
              onSelect: (value) => setState(() => {currency = value})),
        ),
      ],
    );
  }

  Subscription getSubscription() {
    return Subscription(
      key: widget.subscription.key,
      title: titleController.text,
      description: descriptionController.text,
      amount: amountController.text,
      currency: currency,
      startDate: startDate,
      renewalPeriod: Renewal(
        every: int.parse(frequencyController.text), 
        timePeriod: TimePeriod.values.firstWhere((element) => element.name == timePeriodController.text)),
    );
  }
}
