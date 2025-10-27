import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/family_provider.dart';
import '../models/family_member.dart';
import '../utils/app_localizations.dart';

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final provider = context.watch<FamilyProvider>();
    final members = provider.members;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.members,
          style: TextStyle(
            fontWeight: FontWeight.bold
          )
          ),
      ),
      body: members.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.noMembers,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: members.length,
              itemBuilder: (context, index) {
                return _buildMemberCard(context, members[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, FamilyMember member) {
    final loc = AppLocalizations.of(context);
    final provider = context.read<FamilyProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          backgroundImage: member.imagePath != null && File(member.imagePath!).existsSync()
              ? FileImage(File(member.imagePath!))
              : null,
          child: member.imagePath == null || !File(member.imagePath!).existsSync()
              ? Icon(
                  Icons.person,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                )
              : null,
        ),
        title: Text(
          member.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${loc.age}: ${member.age} ${loc.years}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/add_edit',
                  arguments: member.id,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
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

                if (confirm == true && member.id != null) {
                  await provider.deleteMember(member.id!);
                }
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: member.id,
          );
        },
      ),
    );
  }
}