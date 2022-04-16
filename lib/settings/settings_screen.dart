import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/settings/settings_state.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: const SettingsPage(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SettingsCubit, SettingsState>(
        bloc: context.read<SettingsCubit>(),
        listener: (BuildContext context, SettingsState state) {
          if (state.error != null) {
            // TODO your code here
          }
        },
        builder: (BuildContext context, SettingsState state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          final user = state.user;
          return SettingsList(
            sections: [
              SettingsSection(
                title: const Text('Account'),
                tiles: <SettingsTile>[
                  if (user != null)
                    SettingsTile.navigation(
                      leading: GoogleUserCircleAvatar(
                        identity: user,
                      ),
                      title: Text(user.displayName ?? ''),
                      description: Text(user.email),
                    )
                  else
                    SettingsTile.navigation(
                      title: ElevatedButton(
                        onPressed: () => context.read<SettingsCubit>().signin(),
                        child: const Text('Sign In'),
                      ),
                    ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.format_paint),
                    title: const Text('Dark Mode'),
                    trailing: DropdownButton(
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
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
