import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsScreen extends StatefulWidget {
  final Function() onSettingsChanged;

  const SettingsScreen({super.key, required this.onSettingsChanged});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  late Color _xColor;
  late Color _oColor;
  late Color _boardColor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _xColor = Color(_prefs.getInt('xColor') ?? Colors.green.value);
      _oColor = Color(_prefs.getInt('oColor') ?? Colors.red.value);
      _boardColor =
          Color(_prefs.getInt('boardColor') ?? Colors.blueAccent.value);
      _isLoading = false;
    });
  }

  void _saveColorPreference(String key, Color color) async {
    await _prefs.setInt(key, color.value);
    widget.onSettingsChanged();
  }

  void _showColorPickerDialog(
      String title, Color currentColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal.shade50,
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('X Color'),
              trailing: Container(
                width: 30,
                height: 30,
                color: _xColor,
              ),
              onTap: () {
                _showColorPickerDialog('Pick X Color', _xColor, (color) {
                  setState(() {
                    _xColor = color;
                    _saveColorPreference('xColor', color);
                  });
                });
              },
            ),
            ListTile(
              title: const Text('O Color'),
              trailing: Container(
                width: 30,
                height: 30,
                color: _oColor,
              ),
              onTap: () {
                _showColorPickerDialog('Pick O Color', _oColor, (color) {
                  setState(() {
                    _oColor = color;
                    _saveColorPreference('oColor', color);
                  });
                });
              },
            ),
            ListTile(
              title: const Text('Board Color'),
              trailing: Container(
                width: 30,
                height: 30,
                color: _boardColor,
              ),
              onTap: () {
                _showColorPickerDialog('Pick Board Color', _boardColor,
                    (color) {
                  setState(() {
                    _boardColor = color;
                    _saveColorPreference('boardColor', color);
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
