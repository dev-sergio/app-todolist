import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/tarefas.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({Key? key, required this.tarefas, required this.onDelete})
      : super(key: key);

  final Tarefas tarefas;
  final Function(Tarefas) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(tarefas.date),
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                tarefas.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
                label: 'Deletar',
                backgroundColor: Colors.red,
                icon: Icons.delete,
                onPressed: (context) {
                  onDelete(tarefas);
                },
              ),
          ],
        ),
      ),
    );
  }
}
