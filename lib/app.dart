import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/cubits/settings/settings_cubit.dart';
import 'package:my_pesa/data/transactions_repository.dart';
import 'package:my_pesa/pages/categories_page.dart';
import 'package:my_pesa/pages/insights_page.dart';
import 'package:my_pesa/pages/settings_page.dart';
import 'package:my_pesa/pages/transactions_page.dart';

class App extends StatelessWidget {
  App({super.key})
      : settingsCubit = SettingsCubit(),
        databaseCubit =
            DatabaseCubit(transactionsRepository: TransactionsRepository());

  final SettingsCubit settingsCubit;
  final DatabaseCubit databaseCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => settingsCubit,
        ),
        BlocProvider(
          create: (_) => databaseCubit,
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp(
        title: 'myPesa',
        debugShowCheckedModeBanner: false,
        themeMode: context.select<SettingsCubit, ThemeMode>(
          (cubit) => cubit.state.themeMode,
        ),
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
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  final bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Transactions',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.data_exploration),
      label: 'Insights',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: 'Categories',
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
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            TransactionsPage(),
            InsightsPage(),
            CategoriesPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: bottomNavigationBarItems,
          type: BottomNavigationBarType.fixed,
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
