import 'package:flutter/material.dart';
import 'package:todo_list/repositories/tarefas_repository.dart';
import 'package:todo_list/widget/todo_list_item.dart';

import '../models/tarefas.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController tarefasController = TextEditingController();
  final TarefasRepository tarefasRepository = TarefasRepository();

  List<Tarefas> tarefas = [];
  Tarefas? tarefaDeletada;
  int? indexTarefaDeletada;

  String? erroText;

  @override
  void initState() {
    super.initState();
    tarefasRepository.getListaTarefas().then((value) => {
      setState(() {
        tarefas = value;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tarefasController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Tarefas',
                          errorText: erroText,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Color(0xff00d7f3),
                          )
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = tarefasController.text;
                        if (text.isEmpty){
                          setState(() {
                            erroText = "O titulo não pode estar vazio";
                          });
                          return;
                        }
                        setState(() {
                          Tarefas tarefa = Tarefas(
                            title: text,
                            date: DateTime.now(),
                          );
                          tarefas.add(tarefa);
                          erroText = null;
                        });
                        tarefasController.clear();
                        tarefasRepository.saveListaTarefas(tarefas);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14)),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Tarefas tarefa in tarefas)
                        TodoListItem(tarefas: tarefa, onDelete: onDelete),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${tarefas.length} tarefas pendentes',
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDialogDeletaTodasTarefas,
                      child: const Text(
                        'Limpar tudo',
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Tarefas tarefa) {
    tarefaDeletada = tarefa;
    indexTarefaDeletada = tarefas.indexOf(tarefa);

    setState(() {
      tarefas.remove(tarefa);
    });
    tarefasRepository.saveListaTarefas(tarefas);


    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${tarefa.title} foi removida com sucesso!',
          style: const TextStyle(color: Color(0xffffDDff)),
        ),
        backgroundColor: Colors.deepPurple,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xffff3737),
          onPressed: () {
            setState(() {
              tarefas.insert(indexTarefaDeletada!, tarefaDeletada!);
            });
            tarefasRepository.saveListaTarefas(tarefas);

          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDialogDeletaTodasTarefas() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Limpar tudo?'),
              content: const Text(
                  'Você tem certeza que deseja apagar todas as tarefas?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style:
                        TextButton.styleFrom(primary: const Color(0xff00d7f3)),
                    child: const Text('Cancelar')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      deletaTodasTarefas();
                    },
                    style: TextButton.styleFrom(primary: Colors.red),
                    child: const Text('Limpar'))
              ],
        ));
  }

  void deletaTodasTarefas(){
    setState(() {
      tarefas.clear();
    });
    tarefasRepository.saveListaTarefas(tarefas);
  }
}
