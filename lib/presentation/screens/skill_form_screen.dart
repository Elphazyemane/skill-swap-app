import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/skill_listing.dart';
import '../blocs/skill_bloc.dart';

class SkillFormScreen extends StatefulWidget {
  final SkillListing? skill;
  const SkillFormScreen({super.key, this.skill});

  @override
  State<SkillFormScreen> createState() => _SkillFormScreenState();
}

class _SkillFormScreenState extends State<SkillFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _offeringController;
  late final TextEditingController _wantingController;

  bool get isEditing => widget.skill != null;

  @override
  void initState() {
    super.initState();
    _offeringController =
        TextEditingController(text: widget.skill?.offering ?? '');
    _wantingController =
        TextEditingController(text: widget.skill?.wanting ?? '');
  }

  @override
  void dispose() {
    _offeringController.dispose();
    _wantingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SkillBloc, SkillState>(
      listener: (context, state) {
        if (state is SkillCreated || state is SkillUpdated) {
          Navigator.pop(context);
        } else if (state is SkillsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Listing' : 'New Listing'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Skill You Are Offering',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _offeringController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Guitar lessons, Python tutoring...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a skill you are offering';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Skill You Want in Return',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _wantingController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'e.g. I want to learn cooking, photography...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a skill you want';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isEditing ? 'Update Listing' : 'Post Listing',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        final updated = widget.skill!.copyWith(
          offering: _offeringController.text.trim(),
          wanting: _wantingController.text.trim(),
        );
        context.read<SkillBloc>().add(UpdateSkillEvent(updated));
      } else {
        context.read<SkillBloc>().add(CreateSkillEvent(
              offering: _offeringController.text.trim(),
              wanting: _wantingController.text.trim(),
            ));
      }
    }
  }
}