import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class EditableListTile extends StatefulWidget {
  final String text;
  final String fieldToUpdate;
  final IconData iconLeading;
  final int fieldLength;
  final bool isEditable;
  final Function(String text, String fieldToUpdata) onUpdate;

  const EditableListTile({
    super.key,
    required this.text,
    required this.fieldToUpdate,
    required this.iconLeading,
    required this.onUpdate,
    required this.fieldLength,
    this.isEditable = true,
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

  void _startEditing() => setState(() {
        _isEditing = true;
        _textEditingController.text = _text;
      });

  void _saveChanges() {
    setState(() {
      _text = _textEditingController.text;
      _isEditing = false;
    });
    widget.onUpdate(widget.fieldToUpdate, _text);
  }

  Widget _buildTrailingIcon() {
    if (!widget.isEditable) {
      return const Icon(
        Icons.edit_off_rounded,
        color: Colors.white,
      );
    } else {
      return _isEditing
          ? IconButton(
              onPressed: _saveChanges,
              icon: const Icon(
                Icons.check,
                color: Colors.white,
                size: 25,
              ),
            )
          : const Icon(
              Icons.edit,
              color: Colors.white,
              size: 25,
            );
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        leading: Icon(
          widget.iconLeading,
          color: Colors.white,
          size: 30,
        ),
        title: (widget.isEditable && _isEditing)
            ? Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextField(
                  maxLength: (widget.fieldToUpdate == "Nickname" ||
                          widget.fieldToUpdate == "Username")
                      ? widget.fieldLength
                      : null,
                  decoration: drawerTextDecoration,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                  ),
                  controller: _textEditingController,
                ),
              )
            : Text(
                _text,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
        subtitle: widget.fieldToUpdate == "Nickname"
            ? const Text(
                "Friend's nickname",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              )
            : Text(
                widget.fieldToUpdate,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
        trailing: _buildTrailingIcon(),
        onTap: (widget.isEditable && !_isEditing) ? _startEditing : null,
      );

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
