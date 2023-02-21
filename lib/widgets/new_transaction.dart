import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function tsAdd; //właściwość, w której będę przechowywać funkcję

  const NewTransaction(this.tsAdd, {super.key});
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedDate;

  //przejmuje funkcje z innego widgetu
  void _submitData() {
    final title = titleController.text;
    final amount = double.parse(amountController.text);
    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }
    widget.tsAdd(title, amount, _selectedDate);
    Navigator.of(context).pop(); //zamyka dolne menu wpisywania danych
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
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
                  _submitData, //nie wrzucam argumentu, ale wykonuje funkcje
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Text(_selectedDate == null
                      ? 'No date chosen'
                      : 'Chosen date: ${DateFormat('dd.MM.yyyy').format(_selectedDate!)}'),
                  TextButton(
                      onPressed: _showDatePicker,
                      child: const Text(
                        'Pick a date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text(
                'Add Transaction',
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
