import 'package:dana/features/child_profile/presentation/cubit/skills_cubit.dart';
import 'package:dana/features/child_profile/data/repo/skills_repo.dart';
import 'package:dana/features/child_profile/data/models/skill_api_models.dart';
import 'package:dana/features/child_profile/data/services/skills_service.dart';
import 'package:dana/features/parent_profile/data/repo/parent_profile_repository.dart';
import 'package:dana/features/parent_profile/data/datasources/parent_profile_remote_data_source.dart';
import 'package:dana/features/parent_profile/data/models/parent_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSkillsRepo extends SkillsRepo {
  _FakeSkillsRepo() : super(_FakeSkillsService());

  @override
  Future<List<SkillApiModel>> getSkills() => service.getSkills();

  @override
  Future<List<SkillChecklistItemApiModel>> getChecklist({
    required String skillId,
    required String childId,
  }) => service.getChecklist(skillId: skillId, childId: childId);
}

class _FakeSkillsService extends SkillsService {
  _FakeSkillsService() : super(Dio());

  final _skills = [
    SkillApiModel(id: 's1', name: 'Motor', itemCount: 2),
    SkillApiModel(id: 's2', name: 'Speech', itemCount: 2),
  ];

  @override
  Future<List<SkillApiModel>> getSkills() async => _skills;

  @override
  Future<List<SkillChecklistItemApiModel>> getChecklist({
    required String skillId,
    required String childId,
  }) async {
    if (skillId == 's1') {
      return [
        SkillChecklistItemApiModel(id: 'i1', title: 'a', checked: true),
        SkillChecklistItemApiModel(id: 'i2', title: 'b', checked: false),
      ];
    }
    return [
      SkillChecklistItemApiModel(id: 'i3', title: 'c', checked: true),
      SkillChecklistItemApiModel(id: 'i4', title: 'd', checked: true),
    ];
  }

  @override
  Future<void> toggleItem({
    required String childId,
    required String itemId,
    required bool checked,
  }) async {}
}

class _FakeParentRemote implements ParentProfileRemoteDataSource {
  final ParentProfileModel profile;
  _FakeParentRemote(this.profile);

  @override
  Future<ParentProfileModel> getMe() async => profile;

  @override
  Future<void> sendPhoneChangeOtp({required String phone}) async {}

  @override
  Future<ParentProfileModel> patchMe(Map<String, dynamic> body) async =>
      profile;

  @override
  Future<ParentProfileModel> patchMeWithOptionalFile({
    required Map<String, dynamic> bodyJson,
    file,
  }) async =>
      profile;

  @override
  Future<void> addParentProfileImage({required parentId, required file}) async {}

  @override
  Future<ParentChildModel> addChild({
    required String childName,
    required String gender,
    required DateTime birthDate,
  }) async =>
      throw UnimplementedError();

  @override
  Future<ParentChildModel> updateChild({
    required String childId,
    required String childName,
    required String gender,
    required DateTime birthDate,
    profileImage,
  }) async =>
      throw UnimplementedError();
}

void main() {
  test('SkillsCubit persists monthly indicator on loadSkills', () async {
    SharedPreferences.setMockInitialValues({});

    final child = ParentChildModel(
      id: 'c1',
      childName: 'Kid',
      gender: 'male',
      birthDate: DateTime(2024, 1, 1),
      profileImageUrl: null,
    );
    final parent = ParentProfileModel(
      id: 'p1',
      parentName: 'Parent',
      phone: '01000000000',
      children: [child],
    );
    final parentRepo = ParentProfileRepository(_FakeParentRemote(parent));

    final cubit = SkillsCubit(repo: _FakeSkillsRepo(), parentRepo: parentRepo);
    addTearDown(cubit.close);

    await cubit.loadSkills(childId: 'c1');

    final prefs = await SharedPreferences.getInstance();
    final keys =
        prefs.getKeys().where((k) => k.startsWith('skills_indicator_c1_')).toList();
    expect(keys.length, 1);
    expect(prefs.getInt(keys.first), 75);
  });
}

