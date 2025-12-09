import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/communities_service.dart';
import '../../../shared/models/community_model.dart';

final communitiesServiceProvider = Provider<CommunitiesService>((ref) {
  return CommunitiesService();
});

final communitiesByCityProvider = FutureProvider.family<List<CommunityModel>, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(communitiesServiceProvider);
  return await service.getCommunitiesByCity(
    city: params['city'] as String?,
    limit: params['limit'] as int? ?? 20,
  );
});

final communityByIdProvider = FutureProvider.family<CommunityModel?, String>((ref, communityId) async {
  final service = ref.watch(communitiesServiceProvider);
  return await service.getCommunityById(communityId);
});

final userFollowedCommunitiesProvider = FutureProvider.family<List<CommunityModel>, String>((ref, userId) async {
  final service = ref.watch(communitiesServiceProvider);
  return await service.getUserFollowedCommunities(userId);
});

