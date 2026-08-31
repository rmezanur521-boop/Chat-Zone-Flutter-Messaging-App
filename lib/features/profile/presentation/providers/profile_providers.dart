import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(ref.watch(apiClientProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
});

class MyProfileNotifier extends StateNotifier<AsyncValue<ProfileEntity>> {
  final Ref _ref;
  MyProfileNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _ref.read(profileRepositoryProvider).getMyProfile();
      state = AsyncValue.data(profile);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }

  Future<bool> update({
    required String firstName,
    required String lastName,
    String? bio,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    try {
      final profile = await _ref.read(profileRepositoryProvider).updateProfile(
            firstName: firstName,
            lastName: lastName,
            bio: bio,
            gender: gender,
            dateOfBirth: dateOfBirth,
          );
      state = AsyncValue.data(profile);
      return true;
    } on Failure catch (f) {
      state = AsyncValue.error(f.message, StackTrace.current);
      return false;
    }
  }

  Future<bool> uploadPicture(List<int> bytes, String fileName) async {
    try {
      await _ref
          .read(profileRepositoryProvider)
          .uploadProfilePicture(bytes, fileName);
      await load();
      return true;
    } on Failure {
      return false;
    }
  }
}

final myProfileProvider =
    StateNotifierProvider<MyProfileNotifier, AsyncValue<ProfileEntity>>((ref) {
  return MyProfileNotifier(ref);
});

final otherProfileProvider =
    FutureProvider.family<ProfileEntity, String>((ref, userId) async {
  return ref.read(profileRepositoryProvider).getUserProfile(userId);
});
