import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('th', 'TH'));
  }

  // เพิ่ม delegate
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'th': {
      'app_title': 'ต้นไม้ครอบครัว',
      'home': 'หน้าหลัก',
      'members': 'รายการสมาชิก',
      'settings': 'การตั้งค่า',
      'add_member': 'เพิ่มสมาชิกครอบครัว',
      'view_members': 'ดูรายการสมาชิก',
      'no_members': 'ยังไม่มีสมาชิกในครอบครัว',
      'add_first_member': 'เพิ่มสมาชิกคนแรก',
      'name': 'ชื่อ',
      'gender': 'เพศ',
      'male': 'ชาย',
      'female': 'หญิง',
      'birthdate': 'วันเกิด',
      'age': 'อายุ',
      'years': 'ปี',
      'relationships': 'ความสัมพันธ์',
      'father': 'พ่อ',
      'mother': 'แม่',
      'spouse': 'คู่สมรส',
      'children': 'ลูก',
      'save': 'บันทึก',
      'cancel': 'ยกเลิก',
      'edit': 'แก้ไข',
      'delete': 'ลบ',
      'confirm_delete': 'ยืนยันการลบ',
      'delete_message': 'คุณแน่ใจหรือไม่ที่จะลบสมาชิกคนนี้?',
      'yes': 'ใช่',
      'no': 'ไม่',
      'select_image': 'เลือกรูปภาพ',
      'from_camera': 'ถ่ายรูป',
      'from_gallery': 'เลือกจากแกลเลอรี',
      'required_field': 'กรุณากรอกข้อมูล',
      'select_date': 'เลือกวันที่',
      'at_least_one_relation': 'กรุณาเลือกความสัมพันธ์อย่างน้อย 1 อย่าง',
      'language': 'ภาษา',
      'thai': 'ไทย',
      'english': 'อังกฤษ',
      'theme': 'ธีม',
      'light': 'สว่าง',
      'dark': 'มืด',
      'about': 'เกี่ยวกับแอพ',
      'exit': 'ออกจากแอพ',
      'about_text': 'Family Tree App\nเวอร์ชัน 1.0\n\nแอพสำหรับจัดการต้นไม้ครอบครัว\nบันทึกข้อมูลสมาชิกและความสัมพันธ์\nพัฒนาด้วย Flutter',
      'select_father': 'เลือกพ่อ',
      'select_mother': 'เลือกแม่',
      'select_spouse': 'เลือกคู่สมรส',
      'select_children': 'เลือกลูก',
      'none': 'ไม่มี',
      'detail': 'รายละเอียด',
      'member_details': 'รายละเอียดสมาชิก',
    },
    'en': {
      'app_title': 'Family Tree',
      'home': 'Home',
      'members': 'Members',
      'settings': 'Settings',
      'add_member': 'Add Family Member',
      'view_members': 'View Members',
      'no_members': 'No family members yet',
      'add_first_member': 'Add First Member',
      'name': 'Name',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'birthdate': 'Birthdate',
      'age': 'Age',
      'years': 'years',
      'relationships': 'Relationships',
      'father': 'Father',
      'mother': 'Mother',
      'spouse': 'Spouse',
      'children': 'Children',
      'save': 'Save',
      'cancel': 'Cancel',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm_delete': 'Confirm Delete',
      'delete_message': 'Are you sure you want to delete this member?',
      'yes': 'Yes',
      'no': 'No',
      'select_image': 'Select Image',
      'from_camera': 'Take Photo',
      'from_gallery': 'Choose from Gallery',
      'required_field': 'This field is required',
      'select_date': 'Select Date',
      'at_least_one_relation': 'Please select at least one relationship',
      'language': 'Language',
      'thai': 'Thai',
      'english': 'English',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'about': 'About',
      'exit': 'Exit App',
      'about_text': 'Family Tree App\nVersion 1.0\n\nApp for managing family tree\nRecord members and relationships\nDeveloped with Flutter',
      'select_father': 'Select Father',
      'select_mother': 'Select Mother',
      'select_spouse': 'Select Spouse',
      'select_children': 'Select Children',
      'none': 'None',
      'detail': 'Detail',
      'member_details': 'Member Details',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String get appTitle => translate('app_title');
  String get home => translate('home');
  String get members => translate('members');
  String get settings => translate('settings');
  String get addMember => translate('add_member');
  String get viewMembers => translate('view_members');
  String get noMembers => translate('no_members');
  String get addFirstMember => translate('add_first_member');
  String get name => translate('name');
  String get gender => translate('gender');
  String get male => translate('male');
  String get female => translate('female');
  String get birthdate => translate('birthdate');
  String get age => translate('age');
  String get years => translate('years');
  String get relationships => translate('relationships');
  String get father => translate('father');
  String get mother => translate('mother');
  String get spouse => translate('spouse');
  String get children => translate('children');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get edit => translate('edit');
  String get delete => translate('delete');
  String get confirmDelete => translate('confirm_delete');
  String get deleteMessage => translate('delete_message');
  String get yes => translate('yes');
  String get no => translate('no');
  String get selectImage => translate('select_image');
  String get fromCamera => translate('from_camera');
  String get fromGallery => translate('from_gallery');
  String get requiredField => translate('required_field');
  String get selectDate => translate('select_date');
  String get atLeastOneRelation => translate('at_least_one_relation');
  String get language => translate('language');
  String get thai => translate('thai');
  String get english => translate('english');
  String get theme => translate('theme');
  String get light => translate('light');
  String get dark => translate('dark');
  String get about => translate('about');
  String get exit => translate('exit');
  String get aboutText => translate('about_text');
  String get selectFather => translate('select_father');
  String get selectMother => translate('select_mother');
  String get selectSpouse => translate('select_spouse');
  String get selectChildren => translate('select_children');
  String get none => translate('none');
  String get detail => translate('detail');
  String get memberDetails => translate('member_details');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['th', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}