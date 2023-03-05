import 'dart:io';

// import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

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
      home: const MyHomePage(),
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

  List<Widget> _buildLandscapeContent(Function chartBox, txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show chart',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Switch.adaptive(
              value: _showChart,
              activeColor: Theme.of(context).colorScheme.secondary,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              }),
        ],
      ),
      _showChart ? chartBox(0.6) : txList
    ];
  }

  CupertinoNavigationBar _buildCupertinoNavBar() {
    return CupertinoNavigationBar(
      middle: const Text('Personal Expenses App'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoButton(
            onPressed: () => _startNewTransaction(context),
            alignment: Alignment.topCenter,
            child: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
    );
  }

  AppBar _buildMaterialAppBar(double curScaleValue) {
    return AppBar(
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
  }

  List<Widget> _buildPortraitContent(Function chartBox, txList) {
    return [chartBox(0.25), txList];
  }

  @override
  Widget build(BuildContext context) {
    final double curScaleValue = MediaQuery.of(context).textScaleFactor;
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final dynamic appBar = Platform.isIOS
        ? _buildCupertinoNavBar()
        : _buildMaterialAppBar(curScaleValue);

    //mozemy wywolac widget za pomoca funkcji i zmieniac jego parametry
    SizedBox chartBox(double size) {
      return SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              size,
          child: Chart(_recentTransactions));
    }

    final txList = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.78,
        child: TransactionList(_userTransactions, _deleteTransaction));

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape) ..._buildLandscapeContent(chartBox, txList),
              if (!isLandscape) ..._buildPortraitContent(chartBox, txList)
            ],
          ),
        ),
      ),
      floatingActionButton: Platform.isIOS
          ? const SizedBox()
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startNewTransaction(context),
            ),
    );
  }
}
