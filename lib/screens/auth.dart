import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/community_list_provider.dart';
import 'package:frontend/provider/login_provider.dart';
import 'package:frontend/provider/preference_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/services/getCommunities.dart';
import 'package:frontend/services/login.dart';
import 'package:frontend/services/signup.dart';
import 'package:flutter/material.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;

  var _enteredEmail = "";
  var _enteredPassword = "";
  var _enteredUsername = "";
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (isValid) {
      _form.currentState!.save();
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        try {
          final userCredential =
              await loginUser(email: _enteredEmail, password: _enteredPassword);
          if (userCredential["status"] == "Failed") {
            throw Exception(userCredential["message"]);
          }
          ref.watch(tokenProvider.notifier).update(userCredential['token']);
          ref.watch(userProvider.notifier).update(userCredential['username']);
          ref
              .watch(preferenceProvider.notifier)
              .update(userCredential['preferences']);


          final getComm = await getCommunities(token: userCredential['token']);
          if (getComm["status"] == "Failed") {
            throw Exception(getComm["message"]);
          }
          final communities = getComm['CommunitiesJoinedByUser'];
          ref
              .watch(communityListProvider.notifier)
              .storeCommunities(communities);
          Navigator.of(context).pop();

          ref.watch(loginProvider.notifier).login();
        } on Exception catch (e) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Error"),
                    content: Text(e.toString()),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));

          setState(() {
            _isAuthenticating = false;
          });
        }
      } else {
        try {
          final userCredential = await registerUser(
            name: _enteredUsername,
            email: _enteredEmail,
            password: _enteredPassword,
          );
          if (userCredential["status"] == "Failed") {
            throw Exception(userCredential["message"]);
          }
          ref.watch(tokenProvider.notifier).update(userCredential['token']);
          ref.watch(userProvider.notifier).update(_enteredUsername);
          ref.watch(preferenceProvider.notifier).update([]);
          Navigator.of(context).pop();
          ref.watch(loginProvider.notifier).login();
          setState(() {
            _isAuthenticating = false;
          });
        } on Exception catch (error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Error"),
                    content: Text(error.toString()),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));

          setState(() {
            _isAuthenticating = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        width: 300,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text("Welcome to STUD - COM",
                style: Theme.of(context).textTheme.headlineSmall),
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (!_isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                            autocorrect: true,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null || value.trim().length < 4) {
                                return 'Please enter at least 4 characters';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Please must be atleast 6 charachters long.';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_isAuthenticating)
                          const CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(
                              !_isLogin ? 'Sign up' : 'Login',
                            ),
                          ),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create an account'
                                : 'I already have an account.'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
