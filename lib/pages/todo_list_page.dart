import 'package:flutter/material.dart';
import 'package:todo_list/widget/todo_list_item.dart';

import '../models/tarefas.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController tarefasController = TextEditingController();

  List<Tarefas> tarefas = [];
  Tarefas? tarefaDeletada;
  int? indexTarefaDeletada;

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
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Tarefas'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = tarefasController.text;
                        setState(() {
                          Tarefas tarefa = Tarefas(
                            title: text,
                            date: DateTime.now(),
                          );
                          tarefas.add(tarefa);
                          tarefasController.clear();
                        });
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
                      for(Tarefas tarefa in tarefas)
                        TodoListItem(
                          tarefas: tarefa,
                          onDelete: onDelete
                        ),
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
                      onPressed: () {},
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

  void onDelete(Tarefas tarefa){
    tarefaDeletada = tarefa;
    indexTarefaDeletada = tarefas.indexOf(tarefa);

    setState(() {
      tarefas.remove(tarefa);
    });

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
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
