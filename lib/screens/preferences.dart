import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dummydata/skills.dart';
import 'package:frontend/provider/preference_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/services/sendPreferences.dart';
import 'package:frontend/widgets/skills.dart';

class Preferences extends ConsumerStatefulWidget {
  @override
  ConsumerState<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends ConsumerState<Preferences> {
  List<String> prefernces = [];

  void _togglePreference(String preference, bool value) {
    setState(() {
      if (!value) {
        if (prefernces.contains(preference)) {
          prefernces.remove(preference);
        }
      } else {
        if (!prefernces.contains(preference)) {
          prefernces.add(preference);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 600,
      color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.6),
      child: Column(
        children: [
          Text(
            "Tell us about your preferences...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3, 
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                return ToggleSkills(
                  text: skills[index],
                  onToggle: _togglePreference,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              dynamic res = await sendPreferences(
                userID: ref.read(tokenProvider),
                preferences: prefernces,
              );
              ref.watch(preferenceProvider.notifier).update(prefernces);
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
