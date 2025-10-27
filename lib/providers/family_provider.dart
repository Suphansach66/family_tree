import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/family_member.dart';

class FamilyProvider with ChangeNotifier {
  Database? _database;
  List<FamilyMember> _members = [];
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('th', 'TH');

  List<FamilyMember> get members => [..._members];
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  FamilyProvider() {
    _initDatabase();
    _loadPreferences();
  }

  Future<void> _initDatabase() async {
    if (_database != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'family_tree.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE family_members (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            gender TEXT NOT NULL,
            birthdate TEXT NOT NULL,
            image_path TEXT,
            spouse_id INTEGER,
            father_id INTEGER,
            mother_id INTEGER,
            children_ids TEXT
          )
        ''');
      },
    );

    await loadMembers();
  }

  
  Future<void> loadMembers() async {
    if (_database == null) return;

    final List<Map<String, dynamic>> maps = await _database!.query('family_members');
    _members = maps.map((map) => FamilyMember.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addMember(FamilyMember member) async {
    if (_database == null) return;

    final id = await _database!.insert('family_members', member.toMap());
    
    await loadMembers();
    
    await _updateBidirectionalRelationships(
      id,
      spouseId: member.spouseId,
      fatherId: member.fatherId,
      motherId: member.motherId,
      childrenIds: member.childrenIds,
    );

    await loadMembers();
  }

  Future<void> updateMember(FamilyMember member) async {
    if (_database == null || member.id == null) return;

    await _database!.update(
      'family_members',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );

    await loadMembers();

    await _updateBidirectionalRelationships(
      member.id!,
      spouseId: member.spouseId,
      fatherId: member.fatherId,
      motherId: member.motherId,
      childrenIds: member.childrenIds,
    );

    await loadMembers();
  }

  Future<void> deleteMember(int id) async {
    if (_database == null) return;

    await _removeFromAllRelationships(id);

    await _database!.delete(
      'family_members',
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadMembers();
  }

  
  Future<void> _updateBidirectionalRelationships(
    int memberId, {
    int? spouseId,
    int? fatherId,
    int? motherId,
    List<int>? childrenIds,
  }) async {
    if (spouseId != null) {
      try {
        final spouse = _members.firstWhere((m) => m.id == spouseId);
        if (spouse.spouseId != memberId) {
          await _database!.update(
            'family_members',
            {'spouse_id': memberId},
            where: 'id = ?',
            whereArgs: [spouseId],
          );
        }
      } catch (e) {
        print('Spouse not found: $spouseId');
      }
    }

    if (fatherId != null) {
      try {
        final father = _members.firstWhere((m) => m.id == fatherId);
        if (!father.childrenIds.contains(memberId)) {
          final updatedChildren = [...father.childrenIds, memberId];
          await _database!.update(
            'family_members',
            {'children_ids': _encodeChildrenIds(updatedChildren)},
            where: 'id = ?',
            whereArgs: [fatherId],
          );
        }
      } catch (e) {
        print('Father not found: $fatherId');
      }
    }

    if (motherId != null) {
      try {
        final mother = _members.firstWhere((m) => m.id == motherId);
        if (!mother.childrenIds.contains(memberId)) {
          final updatedChildren = [...mother.childrenIds, memberId];
          await _database!.update(
            'family_members',
            {'children_ids': _encodeChildrenIds(updatedChildren)},
            where: 'id = ?',
            whereArgs: [motherId],
          );
        }
      } catch (e) {
        print('Mother not found: $motherId');
      }
    }

    if (childrenIds != null) {
      try {
        final member = _members.firstWhere((m) => m.id == memberId);
        for (final childId in childrenIds) {
          try {
            final child = _members.firstWhere((m) => m.id == childId);
            
            Map<String, dynamic> updates = {};
            if (member.gender == 'Male' && child.fatherId != memberId) {
              updates['father_id'] = memberId;
            } else if (member.gender == 'Female' && child.motherId != memberId) {
              updates['mother_id'] = memberId;
            }

            if (updates.isNotEmpty) {
              await _database!.update(
                'family_members',
                updates,
                where: 'id = ?',
                whereArgs: [childId],
              );
            }
          } catch (e) {
            print('Child not found: $childId');
          }
        }
      } catch (e) {
        print('Member not found: $memberId');
      }
    }
  }

  Future<void> _removeFromAllRelationships(int memberId) async {
    final spouses = _members.where((m) => m.spouseId == memberId);
    for (final spouse in spouses) {
      await _database!.update(
        'family_members',
        {'spouse_id': null},
        where: 'id = ?',
        whereArgs: [spouse.id],
      );
    }

    final childrenWithFather = _members.where((m) => m.fatherId == memberId);
    for (final child in childrenWithFather) {
      await _database!.update(
        'family_members',
        {'father_id': null},
        where: 'id = ?',
        whereArgs: [child.id],
      );
    }

    final childrenWithMother = _members.where((m) => m.motherId == memberId);
    for (final child in childrenWithMother) {
      await _database!.update(
        'family_members',
        {'mother_id': null},
        where: 'id = ?',
        whereArgs: [child.id],
      );
    }

    for (final member in _members) {
      if (member.childrenIds.contains(memberId)) {
        final updatedChildren = member.childrenIds.where((id) => id != memberId).toList();
        await _database!.update(
          'family_members',
          {'children_ids': _encodeChildrenIds(updatedChildren)},
          where: 'id = ?',
          whereArgs: [member.id],
        );
      }
    }
  }

  String _encodeChildrenIds(List<int> ids) {
    return '[${ids.join(',')}]';
  }

  
  FamilyMember? getMemberById(int id) {
    try {
      return _members.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('theme') ?? 'light';
    final languageCode = prefs.getString('language') ?? 'th';

    _themeMode = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _locale = Locale(languageCode, languageCode == 'th' ? 'TH' : 'US');
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
    notifyListeners();
  }
}