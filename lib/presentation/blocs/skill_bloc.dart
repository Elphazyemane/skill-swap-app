import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/skill_listing.dart';
import '../../data/repositories/skill_repository.dart';

part 'skill_event.dart';
part 'skill_state.dart';

class SkillBloc extends Bloc<SkillEvent, SkillState> {
  final SkillRepository skillRepository;
  List<SkillListing> _skills = [];

  SkillBloc({required this.skillRepository}) : super(const SkillInitial()) {
    on<FetchSkillsEvent>(_onFetchSkills);
    on<CreateSkillEvent>(_onCreateSkill);
    on<UpdateSkillEvent>(_onUpdateSkill);
    on<DeleteSkillEvent>(_onDeleteSkill);
  }

  Future<void> _onFetchSkills(
      FetchSkillsEvent event, Emitter<SkillState> emit) async {
    emit(const SkillsLoading());
    final (skills, failure) = await skillRepository.getSkills();
    if (failure != null) {
      emit(SkillsError(failure.message));
    } else {
      _skills = skills!;
      emit(SkillsLoaded(_skills));
    }
  }

  Future<void> _onCreateSkill(
      CreateSkillEvent event, Emitter<SkillState> emit) async {
    emit(SkillActionLoading(_skills));
    final newSkill = SkillListing(
      id: 0,
      userId: 1,
      offering: event.offering,
      wanting: event.wanting,
    );
    final (created, failure) = await skillRepository.createSkill(newSkill);
    if (failure != null) {
      emit(SkillsError(failure.message, currentSkills: _skills));
    } else {
      _skills = [created!, ..._skills];
      emit(SkillCreated(_skills));
    }
  }

  Future<void> _onUpdateSkill(
      UpdateSkillEvent event, Emitter<SkillState> emit) async {
    emit(SkillActionLoading(_skills));
    final (updated, failure) = await skillRepository.updateSkill(event.skill);
    if (failure != null) {
      emit(SkillsError(failure.message, currentSkills: _skills));
    } else {
      _skills = _skills
          .map((s) => s.id == updated!.id ? updated : s)
          .toList();
      emit(SkillUpdated(_skills));
    }
  }

  Future<void> _onDeleteSkill(
      DeleteSkillEvent event, Emitter<SkillState> emit) async {
    emit(SkillActionLoading(_skills));
    final (success, failure) = await skillRepository.deleteSkill(event.id);
    if (failure != null || !success) {
      emit(SkillsError(failure?.message ?? 'Delete failed',
          currentSkills: _skills));
    } else {
      _skills = _skills.where((s) => s.id != event.id).toList();
      emit(SkillDeleted(_skills));
    }
  }
}