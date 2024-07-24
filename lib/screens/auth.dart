import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/login_provider.dart';
import 'package:frontend/provider/token_provider.dart';
import 'package:frontend/services/login.dart';
import 'package:frontend/services/signup.dart';
import 'package:frontend/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  File _selectedImage = File("assets/images/sample.jpeg");
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    print("yo");

    if (isValid) {
      _form.currentState!.save();
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        try {
          final userCredential =
              await loginUser(email: _enteredEmail, password: _enteredPassword);
          print(userCredential);
          ref.watch(tokenProvider.notifier).update(userCredential['token']);
          print("Done");
          Navigator.of(context).pop();

          ref.watch(loginProvider.notifier).login();
        } catch (e) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e Authentication failed')),
          );

          setState(() {
            _isAuthenticating = false;
          });
        }
      } else {
        try {
          print("Start");
          final userCredential = await registerUser(
            name: _enteredUsername,
            email: _enteredEmail,
            password: _enteredPassword,
          );
          // ref.watch(tokenProvider.notifier).update(userCredential['token']);
          print("Here");
          Navigator.of(context).pop();
          ref.watch(loginProvider.notifier).login();
          setState(() {
            _isAuthenticating = false;
          });
        } catch (error) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(' $error Authentication failed')),
          );

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
            Text("Welcome to Git Gud",
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
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              _selectedImage = pickedImage;
                            },
                          ),
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
                                !value.contains('@')) {
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
                        // InkWell(
                        //   onTap: () async {
                        //     await signInWithGoogle();
                        //   },
                        //   child: Image.asset("assets/images/google.png"),
                        // ),
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
