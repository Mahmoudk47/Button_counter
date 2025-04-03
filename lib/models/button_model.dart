import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ButtonModel {
  final String id;
  String label;
  int count;
  Color color;

  ButtonModel({
    String? id,
    required this.label,
    required this.count,
    required this.color,
  }) : id = id ?? const Uuid().v4();

  factory ButtonModel.fromJson(Map<String, dynamic> json) {
    return ButtonModel(
      id: json['id'],
      label: json['label'],
      count: json['count'],
      color: Color(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'count': count,
      'color': color.value,
    };
  }

  ButtonModel copyWith({
    String? label,
    int? count,
    Color? color,
  }) {
    return ButtonModel(
      id: id,
      label: label ?? this.label,
      count: count ?? this.count,
      color: color ?? this.color,
    );
  }
}