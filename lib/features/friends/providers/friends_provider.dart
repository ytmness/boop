import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/friends_service.dart';
import '../../../shared/models/friend_model.dart';
import '../../../shared/models/user_model.dart';

final friendsServiceProvider = Provider<FriendsService>((ref) {
  return FriendsService();
});

final friendsProvider = FutureProvider.family<List<UserModel>, String>((ref, userId) async {
  final service = ref.watch(friendsServiceProvider);
  return await service.getFriends(userId);
});

final pendingRequestsProvider = FutureProvider.family<List<FriendModel>, String>((ref, userId) async {
  final service = ref.watch(friendsServiceProvider);
  return await service.getPendingRequests(userId);
});

