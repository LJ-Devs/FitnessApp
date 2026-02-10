import 'dart:async';
import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';
import '../../domain/entities/chat_room_entity.dart';
import '../../domain/usecases/get_chat_rooms_usecase.dart';

class ChatListViewModel extends ChangeNotifier {
  final GetChatRoomsUseCase getChatRoomsUseCase;
  final GetProfileUseCase getProfileUseCase;
  final searchController = TextEditingController();

  ChatListViewModel({
    required this.getChatRoomsUseCase,
    required this.getProfileUseCase,
  });

  List<ChatRoomEntity> _rooms = [];
  List<ChatRoomEntity> get rooms => _rooms;

  final Map<String, UserEntity> _userProfiles = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription? _roomsSubscription;
  bool _isDisposed = false;

  void loadChatRooms(String currentUserId) {
    _isLoading = true;
    notifyListeners();

    _roomsSubscription?.cancel();
    
    _roomsSubscription = getChatRoomsUseCase(currentUserId).listen(
      (chatRooms) {
        if (_isDisposed) return;
        _rooms = chatRooms;

        _loadProfilesForRooms(chatRooms, currentUserId);

        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        if (_isDisposed) return;
        debugPrint("Erro ao carregar salas: $error");
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Method to bring names/photos
  Future<void> _loadProfilesForRooms(List<ChatRoomEntity> rooms, String currentUserId) async {
    bool foundNewProfile = false;

    for (var room in rooms) {
      final otherUserId = room.getOtherUserId(currentUserId);

      if (otherUserId == null) continue;
      
      if (!_userProfiles.containsKey(otherUserId)) {
        final result = await getProfileUseCase(otherUserId);
        
        if (_isDisposed) return;
        
        result.fold(
          (failure) => null,
          (userEntity) {
            _userProfiles[otherUserId] = userEntity;
            foundNewProfile = true;
          },
        );
      }
    }
    // Update UI with new profiles
    if (foundNewProfile && !_isDisposed) {
      notifyListeners();
    }
  }

  UserEntity? getProfile(String userId) {
    return _userProfiles[userId];
  }

  @override
  void dispose() {
    _isDisposed = true;
    _roomsSubscription?.cancel();
    searchController.dispose();
    super.dispose();
  }
}