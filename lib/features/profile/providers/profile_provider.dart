import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/profile_service.dart';
import '../../../shared/models/user_model.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final currentProfileProvider = FutureProvider<UserModel?>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return await service.getCurrentProfile();
});

final profileProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  final service = ref.watch(profileServiceProvider);
  return await service.getProfile(userId);
});

