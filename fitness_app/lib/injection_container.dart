import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Auth
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/view_models/login_view_model.dart';
import 'features/auth/presentation/view_models/register_view_model.dart';
// Profile
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/presentation/view_models/edit_profile_view_model.dart';
import 'features/profile/presentation/view_models/profile_view_model.dart';
// Chat
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_chat_rooms_usecase.dart';
import 'features/chat/domain/usecases/get_messages_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/presentation/view_models/chat_list_view_model.dart';
import 'features/chat/presentation/view_models/chat_view_model.dart';
// Home/Dashboard
import 'features/dashboard/presentation/view_models/dashboard_view_model.dart';
import 'features/home/presentation/view_models/home_view_model.dart';
// Exercises
import 'features/exercises/data/datasources/exercise_remote_data_source.dart';
import 'features/exercises/data/repositories/exercise_repository_impl.dart';
import 'features/exercises/domain/repositories/exercise_repository.dart';
import 'features/exercises/domain/usecases/create_exercise.dart';
import 'features/exercises/domain/usecases/delete_exercise.dart';
import 'features/exercises/domain/usecases/get_all_exercises.dart';
import 'features/exercises/domain/usecases/get_exercises_by_muscle_group.dart';
import 'features/exercises/domain/usecases/update_exercise.dart';
import 'features/exercises/presentation/view_models/exercise_view_model.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  // External Dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  }

  // ------------ Features - Auth ------------
  
  // Presentation Logic (ViewModels)
  sl.registerFactory(() => LoginViewModel(loginUseCase: sl()));
  sl.registerFactory(() => RegisterViewModel(registerUseCase: sl()));

  // Domain Layer (Use Cases)
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Data Layer (Repositories)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Layer (Data Sources)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  // ------------ Features - Profile ------------

  // ViewModels
  sl.registerFactory(() => ProfileViewModel(
    logoutUseCase: sl(), 
    getProfileUseCase: sl(),
  ));
  
  sl.registerFactory(() => EditProfileViewModel(
    updateProfileUseCase: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  // Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firebaseStorage: sl(),
      firebaseAuth: sl(),
      firebaseFirestore: sl(),
    ),
  );

  // ------------ Features - Home/Dashboard ------------
  sl.registerFactory(() => HomeViewModel());
  sl.registerFactory(() => DashboardViewModel(
    getProfileUseCase: sl(),
  ));

  // ------------ Features - Chat ------------

  // ViewModels
  sl.registerFactory(() => ChatListViewModel(
    getChatRoomsUseCase: sl(),
    getProfileUseCase: sl(),
  ));
  sl.registerFactory(() => ChatViewModel(
    sendMessageUseCase: sl(),
    getMessagesUseCase: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => GetChatRoomsUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl()),
  );

  // ------------ Features - Exercises  ------------

  // ViewModels
  sl.registerFactory(() => ExerciseViewModel(
    createExercise: sl(),
    deleteExercise: sl(),
    getExercisesByMuscleGroup: sl(),
    getAllExercises: sl(),
    updateExercise: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => CreateExercise(sl()));
  sl.registerLazySingleton(() => DeleteExercise(sl()));
  sl.registerLazySingleton(() => GetExercisesByMuscleGroup(sl()));
  sl.registerLazySingleton(() => GetAllExercises(sl()));
  sl.registerLazySingleton(() => UpdateExercise(sl()));

  // Repositories
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(firestore: sl()),
  );
}