class TodoItemModel {
  final int id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;

  String text;
  bool isChecked;

  TodoItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    this.endTime,
    this.text = '',
    this.isChecked = false,
  }) {
    text = title;
  }

  factory TodoItemModel.fromJson(Map<String, dynamic> json) {
    return TodoItemModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',

      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,

      isChecked: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }
}
