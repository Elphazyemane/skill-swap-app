part of 'skill_bloc.dart';

abstract class SkillState extends Equatable {
  const SkillState();

  @override
  List<Object?> get props => [];
}

class SkillInitial extends SkillState {
  const SkillInitial();
}

class SkillsLoading extends SkillState {
  const SkillsLoading();
}

class SkillActionLoading extends SkillState {
  final List<SkillListing> currentSkills;
  const SkillActionLoading(this.currentSkills);

  @override
  List<Object?> get props => [currentSkills];
}

class SkillsLoaded extends SkillState {
  final List<SkillListing> skills;
  const SkillsLoaded(this.skills);

  @override
  List<Object?> get props => [skills];
}

class SkillCreated extends SkillState {
  final List<SkillListing> skills;
  const SkillCreated(this.skills);

  @override
  List<Object?> get props => [skills];
}

class SkillUpdated extends SkillState {
  final List<SkillListing> skills;
  const SkillUpdated(this.skills);

  @override
  List<Object?> get props => [skills];
}

class SkillDeleted extends SkillState {
  final List<SkillListing> skills;
  const SkillDeleted(this.skills);

  @override
  List<Object?> get props => [skills];
}

class SkillsError extends SkillState {
  final String message;
  final List<SkillListing> currentSkills;
  const SkillsError(this.message, {this.currentSkills = const []});

  @override
  List<Object?> get props => [message, currentSkills];
}