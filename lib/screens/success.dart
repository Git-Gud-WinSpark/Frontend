import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/services/sendPreferences.dart';
import 'package:frontend/widgets/skills.dart';
import 'package:frontend/dummydata/skills.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Success extends ConsumerStatefulWidget {
  const Success({super.key});

  @override
  ConsumerState<Success> createState() => _SuccessState();
}

class _SuccessState extends ConsumerState<Success> {
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
    // print("object");
    // print(prefernces);
  }

  @override
  Widget build(BuildContext context) {
    print(prefernces);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Center(
          child: Image.asset(
            "assets/images/image.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
          ),
        ),
        Center(
          child: Container(
            width: 400,
            height: 600,
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.6),
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
                      childAspectRatio:
                          3, // Adjust as necessary for button size
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
                    print(ref.read(tokenProvider));
                    dynamic res = await sendPreferences(
                        userID: ref.read(tokenProvider),
                        preferences: prefernces);

                    print("Done");
                    print(res);
                  },
                  child: Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
