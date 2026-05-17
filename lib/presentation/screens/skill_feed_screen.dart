import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/skill_listing.dart';
import '../blocs/skill_bloc.dart';
import '../widgets/skill_card.dart';
import 'skill_form_screen.dart';

class SkillFeedScreen extends StatefulWidget {
  const SkillFeedScreen({super.key});

  @override
  State<SkillFeedScreen> createState() => _SkillFeedScreenState();
}

class _SkillFeedScreenState extends State<SkillFeedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SkillBloc>().add(const FetchSkillsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.swap_horiz_rounded,
            color: Colors.white, size: 20),
      ),
      const SizedBox(width: 10),
      const Text('Skill Swap'),
    ],
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
      onPressed: () =>
          context.read<SkillBloc>().add(const FetchSkillsEvent()),
    ),
  ],
),
      body: BlocConsumer<SkillBloc, SkillState>(
        listener: (context, state) {
          if (state is SkillCreated) {
            _showSnackBar(context, 'Skill listing created!', Colors.green);
          } else if (state is SkillUpdated) {
            _showSnackBar(context, 'Skill listing updated!', Colors.orange);
          } else if (state is SkillDeleted) {
            _showSnackBar(context, 'Skill listing deleted!', Colors.red);
          } else if (state is SkillsError && state.currentSkills.isNotEmpty) {
            _showSnackBar(context, state.message, Colors.red);
          }
        },
        builder: (context, state) {
          if (state is SkillsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SkillsError && state.currentSkills.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<SkillBloc>()
                        .add(const FetchSkillsEvent()),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          List<SkillListing> skills = [];
          if (state is SkillsLoaded) skills = state.skills;
          if (state is SkillCreated) skills = state.skills;
          if (state is SkillUpdated) skills = state.skills;
          if (state is SkillDeleted) skills = state.skills;
          if (state is SkillActionLoading) skills = state.currentSkills;
          if (state is SkillsError) skills = state.currentSkills;

          if (skills.isEmpty) {
            return const Center(
              child: Text('No skill listings yet. Add one!'),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async => context
                    .read<SkillBloc>()
                    .add(const FetchSkillsEvent()),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: skills.length,
                  itemBuilder: (context, index) {
                    final skill = skills[index];
                    return SkillCard(
                      skill: skill,
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<SkillBloc>(),
                            child: SkillFormScreen(skill: skill),
                          ),
                        ),
                      ),
                      onDelete: () => _confirmDelete(context, skill),
                    );
                  },
                ),
              ),
              if (state is SkillActionLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<SkillBloc>(),
              child: const SkillFormScreen(),
            ),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Skill'),
      ),
    );
  }

  void _confirmDelete(BuildContext context, SkillListing skill) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Listing'),
        content: Text('Delete "${skill.offering}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SkillBloc>().add(DeleteSkillEvent(skill.id));
              Navigator.pop(dialogContext);
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}