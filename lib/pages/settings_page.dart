import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pesa/cubits/export/export_cubit.dart';
import 'package:my_pesa/cubits/export/export_screen.dart';
import 'package:my_pesa/cubits/settings/settings_cubit.dart';
import 'package:my_pesa/cubits/settings/settings_state.dart';
import 'package:my_pesa/data/sheet_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  Widget __buildUserAvatar(GoogleSignInAccount? user) {
    if (user != null) {
      return GoogleUserCircleAvatar(
        identity: user,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SettingsCubit, SettingsState>(
        bloc: context.read<SettingsCubit>(),
        listener: (BuildContext context, SettingsState state) {
          if (state.error != null) {
            final snackBar = SnackBar(
              content: Text(
                state.error!.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
            );

            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (BuildContext context, SettingsState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = state.user;
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Account'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    __buildUserAvatar(user),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? '',
                          textAlign: TextAlign.start,
                        ),
                        Text(user?.email ?? '', textAlign: TextAlign.start),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (user != null)
                          ElevatedButton(
                            onPressed: () =>
                                context.read<SettingsCubit>().signout(),
                            child: const Text('Sign Out'),
                          )
                        else
                          ElevatedButton(
                            onPressed: () =>
                                context.read<SettingsCubit>().signin(),
                            child: const Text('Sign In'),
                          )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.format_paint),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('Dark Mode'),
                          ),
                        ],
                      ),
                    ),
                    DropdownButton(
                      // Initial Value
                      value: state.themeMode,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('System'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Dark'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Light'),
                        )
                      ],
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (ThemeMode? newValue) {
                        if (newValue != null) {
                          context.read<SettingsCubit>().setThemeMode(newValue);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocProvider(
                      create: (BuildContext context) => ExportCubit(
                        sheetRepository: SheetRepository(),
                      ),
                      child: const ExportView(),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
