import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/button_model.dart';

class ButtonProvider extends ChangeNotifier {
  List<ButtonModel> _buttons = [];
  bool _hasUnsavedChanges = false;

  List<ButtonModel> get buttons => _buttons;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  ButtonProvider() {
    _loadButtons();
  }

  Future<void> _loadButtons() async {
    final prefs = await SharedPreferences.getInstance();
    final buttonsJson = prefs.getStringList('buttons') ?? [];
    
    _buttons = buttonsJson
        .map((buttonJson) => ButtonModel.fromJson(json.decode(buttonJson)))
        .toList();
    
    notifyListeners();
  }

  Future<void> saveButtons() async {
    final prefs = await SharedPreferences.getInstance();
    final buttonsJson = _buttons
        .map((button) => json.encode(button.toJson()))
        .toList();
    
    await prefs.setStringList('buttons', buttonsJson);
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  void addButton(ButtonModel button) {
    _buttons.add(button);
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  void updateButton(ButtonModel updatedButton) {
    final index = _buttons.indexWhere((button) => button.id == updatedButton.id);
    if (index != -1) {
      _buttons[index] = updatedButton;
      _hasUnsavedChanges = true;
      notifyListeners();
    }
  }

  void deleteButton(String id) {
    _buttons.removeWhere((button) => button.id == id);
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  void decrementButtonCount(String id) {
    final index = _buttons.indexWhere((button) => button.id == id);
    if (index != -1 && _buttons[index].count > 0) {
      _buttons[index] = _buttons[index].copyWith(
        count: _buttons[index].count - 1,
      );
      _hasUnsavedChanges = true;
      notifyListeners();
    }
  }

  int get totalCount {
    return _buttons.fold(0, (sum, button) => sum + button.count);
  }
}