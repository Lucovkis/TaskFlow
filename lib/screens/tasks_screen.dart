import 'package:material_ui/material_ui.dart';

import '../models/task.dart';

class TasksScreen extends StatefulWidget {
  final DateTime selectedDate;
  final List<Task> tasks;

  const TasksScreen({
    super.key,
    required this.selectedDate,
    required this.tasks,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> get sortedTasks {
    final result = widget.tasks.where((task) {
      return task.date.year == widget.selectedDate.year &&
          task.date.month == widget.selectedDate.month &&
          task.date.day == widget.selectedDate.day;
    }).toList();

    result.sort((a, b) {
      if (a.completed != b.completed) {
        return a.completed ? 1 : -1;
      }

      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return result;
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      widget.tasks.add(Task(title: title.trim(), date: widget.selectedDate));
    });
  }

  void showAddTaskDialog() {
    String taskTitle = '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nova tarefa'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              taskTitle = value;
            },
            decoration: const InputDecoration(
              hintText: 'Digite o nome da tarefa',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskTitle.trim().isEmpty) return;

                addTask(taskTitle);
                Navigator.pop(dialogContext);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksForDate = sortedTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FC),
      appBar: AppBar(
        title: const Text('Minhas tarefas'),
        backgroundColor: const Color(0xFF873BFF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '${widget.selectedDate.day.toString().padLeft(2, '0')}/'
              '${widget.selectedDate.month.toString().padLeft(2, '0')}/'
              '${widget.selectedDate.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: tasksForDate.isEmpty
                ? const Center(child: Text('Nenhuma tarefa cadastrada.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasksForDate.length,
                    itemBuilder: (context, index) {
                      final task = tasksForDate[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.completed,
                            activeColor: const Color(0xFF873BFF),
                            onChanged: (value) {
                              setState(() {
                                task.completed = value ?? false;
                              });
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.tasks.remove(task);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        backgroundColor: const Color(0xFF873BFF),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
