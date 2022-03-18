class Tarefas{

  Tarefas({required this.title, required this.date});

  String title;
  DateTime date;

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'date': date.toIso8601String(),
    };
  }
}