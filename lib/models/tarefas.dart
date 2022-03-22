class Tarefas{

  Tarefas({required this.title, required this.date});

  Tarefas.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        date = DateTime.parse(json['date']);

  String title;
  DateTime date;

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'date': date.toIso8601String(),
    };
  }
}