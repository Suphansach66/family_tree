import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/family_provider.dart';
import '../models/family_member.dart';
import '../utils/app_localizations.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final memberId = ModalRoute.of(context)?.settings.arguments as int?;

    if (memberId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.detail)),
        body: Center(child: Text(loc.requiredField)),
      );
    }

    final provider = context.watch<FamilyProvider>();
    final member = provider.getMemberById(memberId);

    if (member == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.detail)),
        body: Center(child: Text(loc.noMembers)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.memberDetails,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/add_edit', arguments: memberId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(loc.confirmDelete),
                  content: Text(loc.deleteMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(loc.no),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(loc.yes),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await provider.deleteMember(memberId);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSection(context, member),
            _buildInfoSection(context, member),
            _buildRelationshipsSection(context, member),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, FamilyMember member) {
    return Container(
      width: double.infinity,
      height: 250,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: member.imagePath != null && File(member.imagePath!).existsSync()
          ? Image.file(File(member.imagePath!), fit: BoxFit.cover)
          : Icon(
              Icons.person,
              size: 120,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
    );
  }

  Widget _buildInfoSection(BuildContext context, FamilyMember member) {
    final loc = AppLocalizations.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(loc.name, member.name),
              const Divider(),
              _buildInfoRow(
                loc.gender,
                member.gender == 'Male' ? loc.male : loc.female,
              ),
              const Divider(),
              _buildInfoRow(loc.birthdate, dateFormat.format(member.birthdate)),
              const Divider(),
              _buildInfoRow(loc.age, '${member.age} ${loc.years}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildRelationshipsSection(BuildContext context, FamilyMember member) {
    final loc = AppLocalizations.of(context);
    final provider = context.read<FamilyProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.relationships,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildRelationRow(
                context,
                loc.father,
                member.fatherId != null
                    ? provider.getMemberById(member.fatherId!)?.name ?? loc.none
                    : loc.none,
                member.fatherId,
              ),
              const Divider(),
              _buildRelationRow(
                context,
                loc.mother,
                member.motherId != null
                    ? provider.getMemberById(member.motherId!)?.name ?? loc.none
                    : loc.none,
                member.motherId,
              ),
              const Divider(),
              _buildRelationRow(
                context,
                loc.spouse,
                member.spouseId != null
                    ? provider.getMemberById(member.spouseId!)?.name ?? loc.none
                    : loc.none,
                member.spouseId,
              ),
              const Divider(),
              _buildChildrenRow(context, loc.children, member, provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelationRow(
    BuildContext context,
    String label,
    String value,
    int? memberId,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: memberId != null
                ? InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: memberId,
                      );
                    },
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenRow(
    BuildContext context,
    String label,
    FamilyMember member,
    FamilyProvider provider,
  ) {
    final loc = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: member.childrenIds.isEmpty
                ? Text(loc.none, style: const TextStyle(fontSize: 16))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: member.childrenIds.map((childId) {
                      final child = provider.getMemberById(childId);
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: childId,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            child?.name ?? loc.none,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
