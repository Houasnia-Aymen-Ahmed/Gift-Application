import 'package:flutter/material.dart';
import '../../shared/constants.dart';

class EditableListTile extends StatefulWidget {
  final String text;
  final String fieldToUpdate;
  final IconData iconLeading;
  final int fieldLength;
  final bool isEditable;
  final Function(String text, String fieldToUpdata) onUpdate;

  const EditableListTile(
      {super.key,
      required this.text,      
      required this.fieldToUpdate,
      required this.iconLeading,
      required this.onUpdate,
      required this.fieldLength,
      this.isEditable = true
      });

  @override
  State<EditableListTile> createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  final TextEditingController _textEditingController = TextEditingController();
  String _text = '';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
    _textEditingController.text = _text;
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _textEditingController.text = _text;
    });
  }

  void _saveChanges() {
    setState(() {
      _text = _textEditingController.text;
      _isEditing = false;
    });
    widget.onUpdate(widget.fieldToUpdate, _text);
  }

  dynamic _getTrailingIcon() {
    if (!widget.isEditable) {
      return const Icon(Icons.edit_off_rounded);
    } else {
      return _isEditing
          ? IconButton(onPressed: _saveChanges, icon: const Icon(Icons.check))
          : const Icon(Icons.edit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      leading: const Icon(Icons.person),
      title: widget.isEditable && _isEditing
          ? Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextField(
                maxLength: (widget.fieldToUpdate == "nickname" || widget.fieldToUpdate == "username" ) ? widget.fieldLength : null,
                decoration: drawerTextDecoration,
                controller: _textEditingController,
              ),
            )
          : Text(_text),
      subtitle: widget.fieldToUpdate == "nickname" ? const Text("friend's nickname") : Text(widget.fieldToUpdate),
      trailing: _getTrailingIcon(),
      onTap: widget.isEditable && !_isEditing ? _startEditing : null,
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
