import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_academy/student/feature/authentication/model/firebaseFunctionUser.dart';
import 'package:smart_academy/student/feature/authentication/model/model_user.dart';
import 'package:smart_academy/student/feature/authentication/view/screen_ui/register/CompleteProfile.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_status.dart';
import 'package:smart_academy/student/feature/dashbord/view/dashbord.dart';
import 'package:smart_academy/student/feature/home/view/home.dart';

class AuthBloc extends Cubit<AuthStatus> {
  AuthBloc() : super(AuthInitial());

  ModelUser? modelUser;

  // Function for email/password login
  Future<void> loginViewModel(
      {required String email, required String password}) async {
    emit(LoginAuthLoading());
    try {
      modelUser = await FunctionFirebaseUser.loginAccount(email, password);
      emit(LoginAuthSuccess());
    } catch (e) {
      emit(LoginAuthError(error: e.toString()));
    }
  }

  // Function for registering a new user
  Future<void> registerViewModel({
    required String name,
    required String password,
    required String numberId,
    required String email,
  }) async {
    emit(RegisterAuthLoading());
    try {
      modelUser = await FunctionFirebaseUser.registerAccount(
          email, name, numberId, password);
      emit(RegisterAuthSuccess());
    } catch (e) {
      emit(RegisterAuthError(error: e.toString()));
    }
  }

  // Function for logging in via Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleUser == null) {
        // Google sign-in was canceled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You don't have an account")),
        );
        return;
      }

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? firebaseUser = userCredential.user;

        // Check if the user exists in Firebase Firestore
        if (firebaseUser != null) {
          // Check if the user document exists in Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('user')
              .doc(firebaseUser.uid)
              .get();

          if (!userDoc.exists) {
            // If the user does not exist, request them to complete their profile
            String name = googleUser.displayName ?? "";
            String uid = userCredential.user!.uid;

            // Create a model user without saving the email
            ModelUser modelUser = ModelUser(
                name: name,
                email: "", // Don't store the email
                numberId: "", // Placeholder, should be updated later
                id: userCredential.user!.uid,
                courses: []);

            // Add user to Firestore without email
            await FirebaseFirestore.instance
                .collection('user')
                .doc(modelUser.id)
                .set({
              'name': name,
              'numberId': modelUser.numberId,
              // Don't store email here
            });

            // Emit state for user to complete their profile
            emit(GoogleUserNeedsProfileCompletion());

            // Redirect to CompleteProfileScreen
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CompleteProfileScreen(userId: modelUser.id),
              ),
            );
          } else {
            // If the user exists, navigate to the HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
        }
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  // Function for registering a new user via Google
  Future<void> registerWithGoogle(BuildContext context) async {
    emit(RegisterAuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(RegisterAuthError(error: "Google login canceled"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if it's a new user
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        // Create the modelUser object
        modelUser = ModelUser(
          id: userCredential.user?.uid ?? '',
          name: userCredential.user?.displayName ?? '',
          email: userCredential.user?.email ?? '',
          numberId: '',
          courses: [],
        );

        // Save user data if needed
        // await FunctionFirebaseUser.saveUserData(modelUser!);

        // Emit state for user to complete their profile
        emit(GoogleUserNeedsProfileCompletion());

        // Redirect to CompleteProfileScreen to fill numberId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteProfileScreen(userId: modelUser!.id),
          ),
        );
      } else {
        // Existing user, proceed with normal login
        modelUser = ModelUser(
          id: userCredential.user?.uid ?? '',
          name: userCredential.user?.displayName ?? '',
          email: userCredential.user?.email ?? '',
          numberId: '', // Fetch numberId from Firestore if necessary
          courses: [], // Retrieve courses if needed
        );
        emit(GoogleUserLoginSuccess());
      }
    } catch (e) {
      emit(RegisterAuthError(
          error: "Google registration failed: ${e.toString()}"));
    }
  }
}
