import './widgets/new_transaction.dart';
import './widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.teal,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        fontFamily: 'Quicksand',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.tealAccent.shade700)
            .copyWith(error: Colors.red.shade800),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 299.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2', title: 'Groceries', amount: 79.85, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (tx) {
        return tx.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7)));
      },
    ).toList();
  }

  void _addNewTransaction(
      String tsTitle, double tsAmount, DateTime tsChosenDate) {
    final tsData = Transaction(
        //nowy obiekt
        id: DateTime.now().toString(),
        title: tsTitle,
        amount: tsAmount,
        date: tsChosenDate);

    setState(() {
      _userTransactions.add(tsData);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expenses App'),
        titleTextStyle: const TextStyle(
            fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 18),
        actions: [
          IconButton(
            onPressed: () => _startNewTransaction(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startNewTransaction(context),
      ),
    );
  }
}
