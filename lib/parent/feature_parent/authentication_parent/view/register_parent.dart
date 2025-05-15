import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:smart_academy/parent/feature_parent/authentication_parent/view_model/auth_parent_state.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view_model/bloc_auth_parent.dart';
import 'package:smart_academy/parent/feature_parent/screen_home_parent/view/screen_home_parent.dart';

class RegisterParent extends StatefulWidget {
  static const String routeName = "RegisterParent";

  const RegisterParent({super.key});

  @override
  State<RegisterParent> createState() => _RegisterParentState();
}

class _RegisterParentState extends State<RegisterParent> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blue.shade700;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.8),
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Parent Registration",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
          splashRadius: 22,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/image/background.png"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900.withOpacity(0.5),
              Colors.blue.shade900.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Create your account",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      controller: nameController,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: emailController,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Basic email validation
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: idController,
                      label: "ID Number",
                      icon: Icons.badge_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your ID number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 36),
                    BlocConsumer<AuthBlocParent, AuthStatusParent>(
                      listener: (context, state) {
                        if (state is RegisterAuthLoadingParent) {
                          setState(() => _isLoading = true);
                        } else if (state is RegisterAuthSuccessParent) {
                          setState(() => _isLoading = false);
                          Navigator.of(context).pushReplacementNamed(
                            ScreenHomeParent.routeName,
                          );
                        } else if (state is RegisterAuthErrorParent) {
                          setState(() => _isLoading = false);
                          Fluttertoast.showToast(
                            msg: state.error,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : registerParent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: _isLoading ? 0 : 6,
                              shadowColor: primaryColor.withOpacity(0.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(
                                    "Register",
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue.shade50,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }

  void registerParent() {
    if (formKey.currentState!.validate() && !_isLoading) {
      FocusScope.of(context).unfocus();
      BlocProvider.of<AuthBlocParent>(context).registerViewModelParent(
        name: nameController.text.trim(),
        password: passwordController.text.trim(),
        numberId: idController.text.trim(),
        email: emailController.text.trim(),
      );
    }
  }
}
