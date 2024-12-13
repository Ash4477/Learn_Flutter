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
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(child: Text('\$${transaction.amount}')),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
        trailing: MediaQuery.of(context).size.width > 400
            ? TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 230, 7, 7),
                ),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                onPressed: () => deleteTransaction(transaction.id),
              )
            : IconButton(
                onPressed: () => deleteTransaction(transaction.id),
                icon: const Icon(Icons.delete),
                color: const Color.fromARGB(255, 230, 7, 7),
              ),
      ),
    );
  }
}
