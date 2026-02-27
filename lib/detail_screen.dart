import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'note.dart';
import 'storage_helper.dart';
import 'draw_screen.dart';

class DetailScreen extends StatefulWidget {
  final Note? note;

  DetailScreen({this.note});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  List<String> _images = [];
  String? _currentNoteId;
  bool _created = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _images = widget.note?.images ?? [];
  }

  Future<void> _autoSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty && _images.isEmpty) return;

    List<Note> notes = await StorageHelper.getNotes();

    if (widget.note == null) {
      if (!_created) {
        // create once for a new note, then update the same note on subsequent saves
        _currentNoteId = DateTime.now().millisecondsSinceEpoch.toString();
        final newNote = Note(
          id: _currentNoteId!,
          title: title.isEmpty ? 'Không có tiêu đề' : title,
          content: content,
          dateTime: DateTime.now(),
          images: _images,
        );
        notes.add(newNote);
        _created = true;
      } else {
        final index = notes.indexWhere((n) => n.id == _currentNoteId);
        if (index != -1) {
          notes[index].title = title.isEmpty ? 'Không có tiêu đề' : title;
          notes[index].content = content;
          notes[index].dateTime = DateTime.now();
          notes[index].images = _images;
        }
      }
    } else {
      final index = notes.indexWhere((n) => n.id == widget.note!.id);
      if (index != -1) {
        notes[index].title = title.isEmpty ? 'Không có tiêu đề' : title;
        notes[index].content = content;
        notes[index].dateTime = DateTime.now();
        notes[index].images = _images;
      }
    }

    await StorageHelper.saveNotes(notes);
  }

  Future<void> _pickImage() async {
    final XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
    final saved = await File(picked.path).copy('${appDir.path}/$fileName');

    setState(() {
      _images.add(saved.path);
    });

    await _autoSave();
  }

  Future<void> _removeImage(int index) async {
    final path = _images[index];
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (e) {}
    setState(() {
      _images.removeAt(index);
    });
    await _autoSave();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _autoSave();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(hintText: 'Tiêu đề', border: InputBorder.none),
              ),
              SizedBox(height: 8),
              Container(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      child: _images.isEmpty
                          ? Center(child: Text('Chưa có ảnh'))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                final imgPath = _images[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(imgPath),
                                          width: 120,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Icon(Icons.close, size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.add_a_photo), onPressed: _pickImage),
                        IconButton(
                          icon: Icon(Icons.brush),
                          onPressed: () async {
                            final path = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DrawingScreen()),
                            );
                            if (path != null && path is String) {
                              setState(() {
                                _images.add(path);
                              });
                              await _autoSave();
                            }
                          },
                        ),
                        SizedBox(height: 4),
                        Text('Ảnh', style: TextStyle(fontSize: 12)),
                        Text('Vẽ', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(hintText: 'Nhập nội dung ghi chú...', border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
