import 'package:flutter/material.dart';
import '../theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  const ProfileScreen({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(height: 10),
              const Text(
                "Vanshika Jaiswal",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text("Flutter Developer Intern"),
              SwitchListTile(
                title: const Text("Dark Mode"),
                value: themeProvider.isDark,
                onChanged: (_) => themeProvider.toggleTheme(),
              )
            ],
          ),
        ),
      ),
    );
  }
}