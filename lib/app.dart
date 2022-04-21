import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/pages/settings_page.dart';
import 'package:my_pesa/pages/transactions_page.dart';
import 'package:my_pesa/settings/settings_cubit.dart';

class App extends StatelessWidget {
  App({Key? key})
      : settingsCubit = SettingsCubit(),
        categoriesCubit = CategoriesCubit(),
        super(key: key);

  final SettingsCubit settingsCubit;
  final CategoriesCubit categoriesCubit;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => settingsCubit,
        ),
        BlocProvider(
          create: (_) => categoriesCubit,
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
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  final _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Transactions',
    ),
    BottomNavigationBarItem(
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
            TransactionsPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: _bottomNavigationBarItems,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(microseconds: 300),
              curve: Curves.bounceInOut,
            );
          },
        ),
      ),
    );
  }
}
