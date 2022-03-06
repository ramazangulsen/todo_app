import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/todoapp/models/todo_model.dart';
import 'package:todo_app/todoapp/providers/all_providers.dart';
import 'package:todo_app/todoapp/widgets/title_widget.dart';
import 'package:todo_app/todoapp/widgets/todo_list_item_widget.dart';
import 'package:todo_app/todoapp/widgets/toolbar_widget.dart';
import 'package:uuid/uuid.dart';

class TodoApp extends ConsumerWidget {
  TodoApp({Key? key}) : super(key: key);

  final newTodoController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allTodos = ref.watch(filteredTodoList);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          const TitleWidget(),
          TextField(
            controller: newTodoController,
            decoration: const InputDecoration(labelText: "Neler yapacaksın?"),
            onSubmitted: (newTodo) {
              ref.read(todoListProvider.notifier).addTodo(newTodo);
            },
          ),
          const SizedBox(height: 20),
          ToolbarWidget(),
          allTodos.isEmpty
              ? Center(child: const Text("There are no completed missions."))
              : const SizedBox(),
          for (var i = 0; i < allTodos.length; i++)
            Dismissible(
              key: ValueKey(allTodos[i].id),
              onDismissed: (_) {
                ref.read(todoListProvider.notifier).removeTodo(allTodos[i]);
              },
              child: ProviderScope(overrides: [
                currentTodoProvider.overrideWithValue(
                  allTodos[i],
                ),
              ], child: const TodoListItemWidget()),
            )
        ],
      ),
    );
  }
}
