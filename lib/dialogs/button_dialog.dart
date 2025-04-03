import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../models/button_model.dart';
import '../providers/button_provider.dart';

class ButtonDialog extends StatefulWidget {
  final ButtonModel? button;

  const ButtonDialog({super.key, this.button});

  @override
  State<ButtonDialog> createState() => _ButtonDialogState();
}

class _ButtonDialogState extends State<ButtonDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _countController;
  late Color _selectedColor;
  bool _useCustomColor = false;

  final List<Color> _presetColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.button?.label ?? '');
    _countController = TextEditingController(
        text: widget.button?.count.toString() ?? '10');
    _selectedColor = widget.button?.color ?? _presetColors[0];
    _useCustomColor = !_presetColors.contains(_selectedColor);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.button != null;
    final title = isEditing ? 'Edit Button' : 'Create New Button';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: 'Button Label',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a label';
                  }
                  if (value.length > 20) {
                    return 'Label must be 20 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countController,
                decoration: const InputDecoration(
                  labelText: 'Count',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a count';
                  }
                  final count = int.tryParse(value);
                  if (count == null) {
                    return 'Please enter a valid number';
                  }
                  if (count < 0) {
                    return 'Count must be 0 or greater';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Button Color:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _useCustomColor,
                    onChanged: (value) {
                      setState(() {
                        _useCustomColor = value!;
                      });
                    },
                  ),
                  const Text('Use custom color'),
                ],
              ),
              const SizedBox(height: 8),
              if (!_useCustomColor)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _presetColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedColor == color
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            if (_selectedColor == color)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                ColorPicker(
                  pickerColor: _selectedColor,
                  onColorChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  pickerAreaHeightPercent: 0.2,
                  enableAlpha: false,
                  displayThumbColor: true,
                  paletteType: PaletteType.hsvWithHue,
                  pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
            ],
          ),
        ),
      ),
      actions: [
        if (isEditing)
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Button'),
                  content: const Text(
                      'Are you sure you want to delete this button?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final buttonProvider =
                            Provider.of<ButtonProvider>(context, listen: false);
                        buttonProvider.deleteButton(widget.button!.id);
                        Navigator.of(context).pop(); // Close confirmation dialog
                        Navigator.of(context).pop(); // Close edit dialog
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final buttonProvider =
                  Provider.of<ButtonProvider>(context, listen: false);
              
              final label = _labelController.text;
              final count = int.parse(_countController.text);
              
              if (isEditing) {
                final updatedButton = widget.button!.copyWith(
                  label: label,
                  count: count,
                  color: _selectedColor,
                );
                buttonProvider.updateButton(updatedButton);
              } else {
                final newButton = ButtonModel(
                  label: label,
                  count: count,
                  color: _selectedColor,
                );
                buttonProvider.addButton(newButton);
              }
              
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}