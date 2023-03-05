import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.deleteTransaction,
  });

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(child: Text('\$${transaction.amount}')),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(DateFormat('EEEE, dd.MM.yyyy').format(transaction.date)),
        trailing: MediaQuery.of(context).size.width > 460
            ? FilledButton.icon(
                onPressed: () => deleteTransaction(transaction.id),
                icon: const Icon(Icons.delete_forever),
                label: const Text('Delete'),
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.red),
                    backgroundColor: MaterialStatePropertyAll(Colors.white)))
            : Container(
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 5)),
                child: IconButton(
                  icon: const Icon(Icons.delete_forever),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => deleteTransaction(transaction.id),
                ),
              ),
      ),
    );
  }
}
