import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myPesa/models/Account.dart';
import 'package:myPesa/utils/load.dart';
import 'package:myPesa/widgets/BalanceWidget.dart';
import 'package:myPesa/widgets/TransactionListWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPesa',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Messages'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  String balance;
  Account _account;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onRefresh() async {
    print("Refresh");
    // Loading of messages
    Account newAccount = await getAccountFromMessages();
    print("Account");
    if(newAccount == null){
      newAccount = await getAccountFromMessages();
    }
    if (mounted) setState(() {
      _account=newAccount;
    });
    if(_account == null){
      _refreshController.refreshFailed();

    } else {
      _refreshController.refreshCompleted();

    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      child: SmartRefresher(
        enablePullDown: true,
        header: WaterDropMaterialHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Scaffold(
          body: getCurrentPage(currentPage, _account, context),
          bottomNavigationBar: FancyBottomNavigation(
            tabs: [
              TabData(iconData: Icons.account_balance, title: "Home"),
              TabData(iconData: Icons.settings, title: "Settings")
            ],
            onTabChangedListener: (position) {
              setState(() {
                currentPage = position;
              });
            },
          ),
        ),
      ),
    );
  }
}

Widget getCurrentPage(int pageNum, Account account, BuildContext context) {
  if (account == null || account.transactions.length == 0) {
    return Container(
        child: Center(
      child: Text("No Messages from MPESA found"),
    ));
  }
  switch (pageNum) {
    case 0:
      return Column(
        children: <Widget>[
          BalanceWidget(account),
          Expanded(
              child:TransactionListWidget(account, account.transactions, false)
          ),
        ],
      );
    case 1:
      return Container();
  }
  ;
}
