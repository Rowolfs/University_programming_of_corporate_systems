class Note {
  final String noteId;            // для mockapi может быть String -> адаптируйте под свой API
  final String title;
  final String body;

  Note({required this.noteId, required this.title, required this.body});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    noteId: json['id'] is String ? json['id'] as String : (json['id']?.toString() ?? ''),
    title: json['title'] as String,
    body: json['body'] as String,
  );

  Map<String, dynamic> toJson() => {
    'noteId': noteId,
    'title': title,
    'body': body,
  };
}
