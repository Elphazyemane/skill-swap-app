import 'package:equatable/equatable.dart';

class SkillListing extends Equatable {
  final int id;
  final int userId;
  final String offering;
  final String wanting;

  const SkillListing({
    required this.id,
    required this.userId,
    required this.offering,
    required this.wanting,
  });

  factory SkillListing.fromJson(Map<String, dynamic> json) {
    return SkillListing(
      id: json['id'] as int,
      userId: json['userId'] as int,
      offering: json['title'] as String,
      wanting: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': offering,
      'body': wanting,
    };
  }

  SkillListing copyWith({
    int? id,
    int? userId,
    String? offering,
    String? wanting,
  }) {
    return SkillListing(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      offering: offering ?? this.offering,
      wanting: wanting ?? this.wanting,
    );
  }

  @override
  List<Object> get props => [id, userId, offering, wanting];
}