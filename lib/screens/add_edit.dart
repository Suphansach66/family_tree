import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../providers/family_provider.dart';
import '../models/family_member.dart';
import '../utils/app_localizations.dart';

class AddEditScreen extends StatefulWidget {
  const AddEditScreen({super.key});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _imagePath;
  String _gender = 'Male';
  DateTime? _birthdate;
  int? _fatherId;
  int? _motherId;
  int? _spouseId;
  List<int> _childrenIds = [];

  bool _isEdit = false;
  int? _editingMemberId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final memberId = ModalRoute.of(context)?.settings.arguments as int?;
    if (memberId != null && !_isEdit) {
      _isEdit = true;
      _editingMemberId = memberId;
      _loadMemberData(memberId);
    }
  }

  void _loadMemberData(int memberId) {
    final provider = context.read<FamilyProvider>();
    final member = provider.getMemberById(memberId);

    if (member != null) {
      _nameController.text = member.name;
      _gender = member.gender;
      _birthdate = member.birthdate;
      _imagePath = member.imagePath;
      _fatherId = member.fatherId;
      _motherId = member.motherId;
      _spouseId = member.spouseId;
      _childrenIds = [...member.childrenIds];
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final provider = context.watch<FamilyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? loc.edit : loc.addMember,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(loc),
              const SizedBox(height: 16),
              _buildNameField(loc),
              const SizedBox(height: 16),
              _buildGenderField(loc),
              const SizedBox(height: 16),
              _buildBirthdateField(loc),
              const SizedBox(height: 24),
              Text(
                loc.relationships,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildFatherField(loc, provider),
              const SizedBox(height: 8),
              _buildMotherField(loc, provider),
              const SizedBox(height: 8),
              _buildSpouseField(loc, provider),
              const SizedBox(height: 8),
              _buildChildrenField(loc, provider),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(loc.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveMember,
                      child: Text(loc.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(AppLocalizations loc) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: _imagePath != null && File(_imagePath!).existsSync()
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(_imagePath!), fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 60,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.selectImage,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNameField(AppLocalizations loc) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: loc.name,
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return loc.requiredField;
        }
        return null;
      },
    );
  }

  Widget _buildGenderField(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.gender, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(loc.male),
                value: 'Male',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(loc.female),
                value: 'Female',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBirthdateField(AppLocalizations loc) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return InkWell(
      onTap: _selectBirthdate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: loc.birthdate,
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          _birthdate != null ? dateFormat.format(_birthdate!) : loc.selectDate,
        ),
      ),
    );
  }

  Widget _buildFatherField(AppLocalizations loc, FamilyProvider provider) {
    final availableFathers = provider.members
        .where(
          (m) =>
              m.gender == 'Male' &&
              m.id != _editingMemberId &&
              m.id != _motherId && 
              m.id != _spouseId && 
              !_childrenIds.contains(m.id),
        )
        .toList();

    return DropdownButtonFormField<int?>(
      value: _fatherId,
      decoration: InputDecoration(
        labelText: loc.selectFather,
        prefixIcon: const Icon(Icons.man),
      ),
      items: [
        DropdownMenuItem<int?>(value: null, child: Text(loc.none)),
        ...availableFathers.map((member) {
          return DropdownMenuItem<int?>(
            value: member.id,
            child: Text(member.name),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _fatherId = value;
        });
      },
    );
  }

  Widget _buildMotherField(AppLocalizations loc, FamilyProvider provider) {
    final availableMothers = provider.members
        .where(
          (m) =>
              m.gender == 'Female' &&
              m.id != _editingMemberId &&
              m.id != _fatherId && 
              m.id != _spouseId && 
              !_childrenIds.contains(m.id), 
        )
        .toList();

    return DropdownButtonFormField<int?>(
      value: _motherId,
      decoration: InputDecoration(
        labelText: loc.selectMother,
        prefixIcon: const Icon(Icons.woman),
      ),
      items: [
        DropdownMenuItem<int?>(value: null, child: Text(loc.none)),
        ...availableMothers.map((member) {
          return DropdownMenuItem<int?>(
            value: member.id,
            child: Text(member.name),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _motherId = value;
        });
      },
    );
  }

  Widget _buildSpouseField(AppLocalizations loc, FamilyProvider provider) {
    final availableSpouses = provider.members
        .where(
          (m) =>
              m.id != _editingMemberId &&
              m.id != _fatherId && 
              m.id != _motherId &&
              !_childrenIds.contains(m.id),
        )
        .toList();

    return DropdownButtonFormField<int?>(
      value: _spouseId,
      decoration: InputDecoration(
        labelText: loc.selectSpouse,
        prefixIcon: const Icon(Icons.favorite),
      ),
      items: [
        DropdownMenuItem<int?>(value: null, child: Text(loc.none)),
        ...availableSpouses.map((member) {
          return DropdownMenuItem<int?>(
            value: member.id,
            child: Text(member.name),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _spouseId = value;
        });
      },
    );
  }

  Widget _buildChildrenField(AppLocalizations loc, FamilyProvider provider) {
    final availableChildren = provider.members
        .where(
          (m) =>
              m.id != _editingMemberId &&
              m.id != _fatherId && 
              m.id != _motherId && 
              m.id != _spouseId, 
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: loc.selectChildren,
            prefixIcon: const Icon(Icons.child_care),
          ),
          child: Wrap(
            spacing: 8,
            children: _childrenIds.isEmpty
                ? [Text(loc.none)]
                : _childrenIds.map((id) {
                    final child = provider.getMemberById(id);
                    return Chip(
                      label: Text(child?.name ?? ''),
                      onDeleted: () {
                        setState(() {
                          _childrenIds.remove(id);
                        });
                      },
                    );
                  }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _selectChildren(loc, availableChildren),
          icon: const Icon(Icons.add),
          label: Text(loc.selectChildren),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final loc = AppLocalizations.of(context);

    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.selectImage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(loc.fromCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(loc.fromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    }
  }

  Future<void> _selectBirthdate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthdate = picked;
      });
    }
  }

  Future<void> _selectChildren(
    AppLocalizations loc,
    List<FamilyMember> availableChildren,
  ) async {
    final selected = await showDialog<List<int>>(
      context: context,
      builder: (context) => _ChildrenSelectionDialog(
        selectedIds: _childrenIds,
        availableChildren: availableChildren,
        loc: loc,
      ),
    );

    if (selected != null) {
      setState(() {
        _childrenIds = selected;
      });
    }
  }

  Future<void> _saveMember() async {
    final loc = AppLocalizations.of(context);
    final provider = context.read<FamilyProvider>();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthdate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.requiredField)));
      return;
    }

    // ตรวจสอบว่าต้องมีความสัมพันธ์อย่างน้อย 1 ถ้า DB ไม่ว่าง
    final isFirstMember = provider.members.isEmpty;
    if (!isFirstMember &&
        _fatherId == null &&
        _motherId == null &&
        _spouseId == null &&
        _childrenIds.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.atLeastOneRelation)));
      return;
    }

    final member = FamilyMember(
      id: _editingMemberId,
      name: _nameController.text,
      gender: _gender,
      birthdate: _birthdate!,
      imagePath: _imagePath,
      fatherId: _fatherId,
      motherId: _motherId,
      spouseId: _spouseId,
      childrenIds: _childrenIds,
    );

    if (_isEdit) {
      await provider.updateMember(member);
    } else {
      await provider.addMember(member);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}

class _ChildrenSelectionDialog extends StatefulWidget {
  final List<int> selectedIds;
  final List<FamilyMember> availableChildren;
  final AppLocalizations loc;

  const _ChildrenSelectionDialog({
    required this.selectedIds,
    required this.availableChildren,
    required this.loc,
  });

  @override
  State<_ChildrenSelectionDialog> createState() =>
      _ChildrenSelectionDialogState();
}

class _ChildrenSelectionDialogState extends State<_ChildrenSelectionDialog> {
  late List<int> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = [...widget.selectedIds];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.loc.selectChildren),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.availableChildren.length,
          itemBuilder: (context, index) {
            final child = widget.availableChildren[index];
            final isSelected = _tempSelected.contains(child.id);

            return CheckboxListTile(
              title: Text(child.name),
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _tempSelected.add(child.id!);
                  } else {
                    _tempSelected.remove(child.id);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.loc.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _tempSelected),
          child: Text(widget.loc.save),
        ),
      ],
    );
  }
}
