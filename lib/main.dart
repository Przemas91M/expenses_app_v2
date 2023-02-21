// import 'package:flutter/services.dart';

import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final double curScaleValue = MediaQuery.of(context).textScaleFactor;
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.teal,
        textTheme: TextTheme(
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
  bool _showChart = false;
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
    final double curScaleValue = MediaQuery.of(context).textScaleFactor;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text('Personal Expenses App'),
      titleTextStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 18 * curScaleValue),
      actions: [
        IconButton(
          onPressed: () => _startNewTransaction(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
    //mozemy wywolac widget za pomoca funkcji i zmieniac jego parametry
    SizedBox chartBox(double size) {
      return SizedBox(
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              size,
          child: Chart(_recentTransactions));
    }

    final txList = SizedBox(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.78,
        child: TransactionList(_userTransactions, _deleteTransaction));

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show chart',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Switch(
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      }),
                ],
              ),
            if (!isLandscape) chartBox(0.25),
            if (!isLandscape) txList,
            if (isLandscape) _showChart ? chartBox(0.6) : txList
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
