part of 'skill_bloc.dart';

abstract class SkillEvent extends Equatable {
  const SkillEvent();

  @override
  List<Object?> get props => [];
}

class FetchSkillsEvent extends SkillEvent {
  const FetchSkillsEvent();
}

class CreateSkillEvent extends SkillEvent {
  final String offering;
  final String wanting;
  const CreateSkillEvent({required this.offering, required this.wanting});

  @override
  List<Object?> get props => [offering, wanting];
}

class UpdateSkillEvent extends SkillEvent {
  final SkillListing skill;
  const UpdateSkillEvent(this.skill);

  @override
  List<Object?> get props => [skill];
}

class DeleteSkillEvent extends SkillEvent {
  final int id;
  const DeleteSkillEvent(this.id);

  @override
  List<Object?> get props => [id];
}