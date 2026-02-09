import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

// Interface (Contract) for the Data Source
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
}

// Implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> login(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Convert Firebase User to Model
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the display name in Firebase
    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(name);
    }

    // Return the model with the new name
    return UserModel(
      uid: userCredential.user!.uid,
      email: email,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}