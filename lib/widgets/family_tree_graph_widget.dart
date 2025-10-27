import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphview/graphview.dart';
import 'package:provider/provider.dart';
import '../providers/family_provider.dart';
import '../models/family_member.dart';

class FamilyTreeGraphWidget extends StatefulWidget {
  const FamilyTreeGraphWidget({super.key});

  @override
  State<FamilyTreeGraphWidget> createState() => _FamilyTreeGraphWidgetState();
}

class _FamilyTreeGraphWidgetState extends State<FamilyTreeGraphWidget> {
  final Graph graph = Graph();
  SugiyamaConfiguration builder = SugiyamaConfiguration();
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    
    builder
      ..nodeSeparation = 30 
      ..levelSeparation = 80 
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FamilyProvider>();
    final members = provider.members;

    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    _buildFamilyGraph(members, provider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitGraphToScreen();
    });

    return InteractiveViewer(
      transformationController: _transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.1,
      maxScale: 3.0,
      child: GraphView(
        graph: graph,
        algorithm: SugiyamaAlgorithm(builder),
        paint: Paint()
          ..color = Theme.of(context).primaryColor
          ..strokeWidth = 1.5  
          ..style = PaintingStyle.stroke,
        builder: (Node node) {
          final data = node.key!.value;
          if (data is FamilyMember) {
            return _buildMemberCard(context, data);
          } else if (data is String && data.startsWith('marriage')) {
            return _buildMarriageNode(context);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _fitGraphToScreen() {
    if (graph.nodes.isEmpty) return;
    
    final double initialScale = 0.8;  
    _transformationController.value = Matrix4.identity()
      ..translate(50.0, 50.0) 
      ..scale(initialScale);
  }

  void _buildFamilyGraph(List<FamilyMember> members, FamilyProvider provider) {
    graph.nodes.clear();
    graph.edges.clear();

    final Map<int, Node> memberNodes = {};
    final Set<int> processedSpouses = {};

    for (var member in members) {
      final node = Node.Id(member);
      memberNodes[member.id!] = node;
      graph.addNode(node);
    }

    for (var member in members) {
      final memberNode = memberNodes[member.id!]!;

      if (member.spouseId != null && !processedSpouses.contains(member.id)) {
        final spouse = provider.getMemberById(member.spouseId!);
        if (spouse != null) {
          final spouseNode = memberNodes[spouse.id!]!;
          
          final marriageNode = Node.Id('marriage_${member.id}_${spouse.id}');
          graph.addNode(marriageNode);

          graph.addEdge(memberNode, marriageNode);
          graph.addEdge(spouseNode, marriageNode);

          final allChildren = {...member.childrenIds, ...spouse.childrenIds};
          for (var childId in allChildren) {
            if (memberNodes.containsKey(childId)) {
              graph.addEdge(marriageNode, memberNodes[childId]!);
            }
          }

          processedSpouses.add(member.id!);
          processedSpouses.add(spouse.id!);
        }
      }
      else if (member.spouseId == null && member.childrenIds.isNotEmpty) {
        for (var childId in member.childrenIds) {
          if (memberNodes.containsKey(childId)) {
            graph.addEdge(memberNode, memberNodes[childId]!);
          }
        }
      }
    }
  }

  Widget _buildMemberCard(BuildContext context, FamilyMember member) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: member.id);
      },
      child: Card(
        elevation: 2,  
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),  
          side: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            width: 1.5, 
          ),
        ),
        child: Container(
          width: 90,  
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18, 
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                backgroundImage: member.imagePath != null &&
                        File(member.imagePath!).existsSync()
                    ? FileImage(File(member.imagePath!))
                    : null,
                child: member.imagePath == null ||
                        !File(member.imagePath!).existsSync()
                    ? Icon(
                        Icons.person,
                        size: 22, 
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
              ),
              const SizedBox(height: 6), 
              Text(
                member.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,  
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2), 
              Text(
                '${member.age} ปี',
                style: TextStyle(
                  fontSize: 9,  
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarriageNode(BuildContext context) {
    return Container(
      width: 30,  
      height: 30,  
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red, width: 1.5), 
      ),
      child: const Icon(
        Icons.favorite,
        color: Colors.red,
        size: 16,  
      ),
    );
  }
}