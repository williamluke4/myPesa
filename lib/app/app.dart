import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/account/account.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/settings/settings_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsCubit()..refreshTransactions(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myPesa',
      themeMode: context
          .select<SettingsCubit, ThemeMode>((cubit) => cubit.state.themeMode),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Transactions',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          controller: _pageController,
          children: const [
            AccountView(),
            SettingsView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: _bottomNavigationBarItems,
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: Duration(microseconds: 300),
                curve: Curves.bounceInOut);
          },
        ),
      ),
    );
  }
}
