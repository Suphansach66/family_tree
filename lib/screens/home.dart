import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/family_provider.dart';
import '../utils/app_localizations.dart';
import '../widgets/family_tree_graph_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final provider = context.watch<FamilyProvider>();
    final hasMembers = provider.members.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: hasMembers
            ? _buildFamilyTreeView(context)
            : _buildEmptyState(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom,
            size: 120,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            loc.noMembers,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/members');
            },
            icon: const Icon(Icons.add),
            label: Text(loc.addMember),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyTreeView(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Column(
      children: [
        Expanded(child: const FamilyTreeGraphWidget()),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 64),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/members');
            },
            icon: const Icon(Icons.list),
            label: Text(loc.viewMembers),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
