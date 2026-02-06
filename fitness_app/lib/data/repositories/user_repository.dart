import '../../domain/entities/app_user.dart';
import '../model/user_model.dart';
import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService _service = FirestoreService();
  final String _collection = 'users';

  Future<void> saveUser(AppUser user) async {
    // AppUser to UserModel
    final model = UserModel(
      uid: user.uid,
      email: user.email,
      name: user.name,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
    );
    await _service.setDocument(_collection, user.uid, model.toFirestore());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _service.getDocument(_collection, uid);
    if (doc.exists && doc.data() != null) {
      // UserModel to AppUser
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}