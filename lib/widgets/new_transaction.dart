import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function tsAdd; //właściwość, w której będę przechowywać funkcję

  const NewTransaction(this.tsAdd, {super.key});
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  //przejmuje funkcje z innego widgetu
  void submitData() {
    final title = titleController.text;
    final amount = double.parse(amountController.text);
    if (title.isEmpty || amount <= 0) {
      return;
    }
    widget.tsAdd(title, amount);
    Navigator.of(context).pop(); //zamyka dolne menu wpisywania danych
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Title'),
            controller: titleController,
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Amount'),
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) =>
                submitData, //nie wrzucam argumentu, ale wykonuje funkcje
          ),
          ElevatedButton(
            onPressed: submitData,
            child: const Text(
              'Add Transaction',
            ),
          ),
        ]),
      ),
    );
  }
}
