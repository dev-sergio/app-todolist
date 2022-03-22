import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tarefas.dart';

const tarefasListKey = 'tarefas_list';

class TarefasRepository {

  late SharedPreferences sharedPreferences;

  Future<List<Tarefas>> getListaTarefas() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(tarefasListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Tarefas.fromJson(e)).toList();
  }
  void saveListaTarefas(List<Tarefas> tarefas){
    final jsonString = json.encode(tarefas);
    sharedPreferences.setString(tarefasListKey, jsonString);
  }
}