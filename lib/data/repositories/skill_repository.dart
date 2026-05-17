import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/skill_remote_datasource.dart';
import '../models/skill_listing.dart';

abstract class SkillRepository {
  Future<(List<SkillListing>?, Failure?)> getSkills();
  Future<(SkillListing?, Failure?)> createSkill(SkillListing skill);
  Future<(SkillListing?, Failure?)> updateSkill(SkillListing skill);
  Future<(bool, Failure?)> deleteSkill(int id);
}

class SkillRepositoryImpl implements SkillRepository {
  final SkillRemoteDataSource remoteDataSource;

  SkillRepositoryImpl({required this.remoteDataSource});

  @override
  Future<(List<SkillListing>?, Failure?)> getSkills() async {
    try {
      final skills = await remoteDataSource.getSkills();
      return (skills, null);
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }

  @override
  Future<(SkillListing?, Failure?)> createSkill(SkillListing skill) async {
    try {
      final created = await remoteDataSource.createSkill(skill);
      return (created, null);
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }

  @override
  Future<(SkillListing?, Failure?)> updateSkill(SkillListing skill) async {
    try {
      final updated = await remoteDataSource.updateSkill(skill);
      return (updated, null);
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }

  @override
  Future<(bool, Failure?)> deleteSkill(int id) async {
    try {
      await remoteDataSource.deleteSkill(id);
      return (true, null);
    } on NotFoundException catch (e) {
      return (false, NotFoundFailure(e.message));
    } on NetworkException catch (e) {
      return (false, NetworkFailure(e.message));
    } on ServerException catch (e) {
      return (false, ServerFailure(e.message));
    } catch (e) {
      return (false, UnknownFailure(e.toString()));
    }
  }
}