import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';

class StorageHelper {
  static const String _keyNotes = 'smart_notes_data';

  // Lưu danh sách ghi chú (Ghi đè)
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonNotes = notes.map((note) => note.toJson()).toList();
    await prefs.setStringList(_keyNotes, jsonNotes);
  }

  // Đọc danh sách ghi chú
  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonNotes = prefs.getStringList(_keyNotes);
    
    if (jsonNotes == null) return [];
    return jsonNotes.map((jsonStr) => Note.fromJson(jsonStr)).toList();
  }
}