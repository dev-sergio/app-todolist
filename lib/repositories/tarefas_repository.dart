import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tarefas.dart';

class TarefasRepository {

  TarefasRepository(){
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }
  late SharedPreferences sharedPreferences;

  void saveListaTarefas(List<Tarefas> tarefas){
    final jsonString = json.encode(tarefas);
    sharedPreferences.setString('tarefas_list', jsonString);
  }
}