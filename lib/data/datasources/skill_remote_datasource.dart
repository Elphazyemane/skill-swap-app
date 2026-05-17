import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/skill_listing.dart';

abstract class SkillRemoteDataSource {
  Future<List<SkillListing>> getSkills();
  Future<SkillListing> createSkill(SkillListing skill);
  Future<SkillListing> updateSkill(SkillListing skill);
  Future<void> deleteSkill(int id);
}

class SkillRemoteDataSourceImpl implements SkillRemoteDataSource {
  final DioClient dioClient;

  SkillRemoteDataSourceImpl({required this.dioClient});

  
  static final List<SkillListing> _localSkills = [];
  static int _nextId = 1;

  @override
  Future<List<SkillListing>> getSkills() async {
    // Return only real user created listings
    return List.from(_localSkills);
  }

  @override
  Future<SkillListing> createSkill(SkillListing skill) async {
    try {
      
      await dioClient.dio.post(
        ApiConstants.skillsEndpoint,
        data: skill.toJson(),
      );
      
      final newSkill = SkillListing(
        id: _nextId++,
        userId: 1,
        offering: skill.offering,
        wanting: skill.wanting,
      );
      _localSkills.insert(0, newSkill);
      return newSkill;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<SkillListing> updateSkill(SkillListing skill) async {
    try {
      // Still call the API
      await dioClient.dio.put(
        '${ApiConstants.skillsEndpoint}/${skill.id}',
        data: skill.toJson(),
      );
      
      final index = _localSkills.indexWhere((s) => s.id == skill.id);
      if (index != -1) {
        _localSkills[index] = skill;
      }
      return skill;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteSkill(int id) async {
    try {
      
      await dioClient.dio.delete(
        '${ApiConstants.skillsEndpoint}/$id',
      );
      
      _localSkills.removeWhere((s) => s.id == id);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 404) {
      return const NotFoundException('Skill listing not found.');
    } else if (e.type == DioExceptionType.connectionError) {
      return const NetworkException('No internet connection.');
    } else {
      return const ServerException('Something went wrong. Try again.');
    }
  }
}