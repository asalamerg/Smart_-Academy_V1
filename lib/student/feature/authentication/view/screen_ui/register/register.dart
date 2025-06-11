import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:smart_academy/shared/widget/validation.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_bloc.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_status.dart';
import 'package:smart_academy/student/feature/home/view/home.dart';

// Default Button Widget (without loading animation)
class DefaultButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  const DefaultButton({
    required this.onPressed,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Default TextFormField Widget (unchanged)
class DefaultTextFormField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const DefaultTextFormField({
    required this.title,
    required this.controller,
    required this.validator,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    super.key,
  });

  @override
  _DefaultTextFormFieldState createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.title,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: Colors.blueAccent)
            : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blueAccent,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        filled: true,
        fillColor: Colors.blue.shade50,
        labelStyle: TextStyle(color: Colors.blue.shade700),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

// Register Screen (without Loading widget or animation)
class Register extends StatefulWidget {
  static const String routeName = "register";

  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Create Your Account",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      DefaultTextFormField(
                        title: "Name",
                        controller: nameController,
                        validator: validation.name,
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      DefaultTextFormField(
                        title: "Email",
                        controller: emailController,
                        validator: validation.email,
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      DefaultTextFormField(
                        title: "Password",
                        controller: passwordController,
                        validator: validation.password,
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      DefaultTextFormField(
                        title: "ID",
                        controller: idController,
                        validator: validation.id,
                        prefixIcon: Icons.badge,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      BlocConsumer<AuthBloc, AuthStatus>(
                        listener: (context, state) {
                          if (state is RegisterAuthSuccess) {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName);
                          } else if (state is RegisterAuthError) {
                            Fluttertoast.showToast(
                              msg: state.error,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        builder: (context, state) {
                          return DefaultButton(
                            onPressed:
                                state is RegisterAuthLoading ? null : register,
                            title: "Register",
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Add Google sign-in button
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).registerViewModel(
        name: nameController.text,
        password: passwordController.text,
        numberId: idController.text,
        email: emailController.text,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    idController.dispose();
    super.dispose();
  }
}
