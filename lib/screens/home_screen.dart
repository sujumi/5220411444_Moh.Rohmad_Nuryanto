import 'package:flutter/material.dart';
import '../services/todo_service.dart';
import '../models/todo_model.dart';
import '../widgets/bottom_navigation.dart'; // Import BottomNavigation

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  List<Todo> _favoriteTodos = [];
  int _selectedIndex = 0; // Menyimpan indeks yang dipilih

  @override
  void initState() {
    super.initState();
    _refreshTodos();
  }

  void _addTodo() async {
    final todo = await _showTodoDialog();
    if (todo != null) {
      _todoService.addTodo(todo);
      _refreshTodos();
    }
  }

  void _editTodo(int index) async {
    final todo = await _showTodoDialog(existingTodo: _todos[index]);
    if (todo != null) {
      _todoService.editTodo(index, todo);
      _refreshTodos();
    }
  }

  Future<Todo?> _showTodoDialog({Todo? existingTodo}) {
    final titleController = TextEditingController(text: existingTodo?.title);
    final descriptionController = TextEditingController(text: existingTodo?.description);

    return showDialog<Todo>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingTodo == null ? 'Add Todo' : 'Edit Todo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final todo = Todo(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                Navigator.of(context).pop(todo);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index) {
    setState(() {
      _todoService.deleteTodo(index);
      _refreshTodos();
    });
  }

  void _refreshTodos() {
    setState(() {
      _todos = _todoService.getTodos();
    });
  }

  void _toggleFavorite(Todo todo) {
    setState(() {
      if (_favoriteTodos.contains(todo)) {
        _favoriteTodos.remove(todo);
      } else {
        _favoriteTodos.add(todo);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/profile');
        break;
      case 2:
        // Tambahkan navigasi untuk halaman notifikasi jika ada
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTodo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Konten GridView
            Expanded(
              flex: 2,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(
                            todo.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(todo.description),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _favoriteTodos.contains(todo) ? Icons.favorite : Icons.favorite_border,
                                  color: _favoriteTodos.contains(todo) ? Colors.red : Colors.grey,
                                ),
                                onPressed: () => _toggleFavorite(todo),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTodo(index),
                              ),
                            ],
                          ),
                          onTap: () => _editTodo(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // ListView untuk Menu Tambahan
            Expanded(
              flex: 1,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      'Favorites',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Menampilkan daftar favorit
                  ..._favoriteTodos.map((todo) => ListTile(
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _favoriteTodos.remove(todo);
                            });
                          },
                        ),
                      )),
                  const Divider(),
                  // Opsi menu tambahan
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.blueAccent),
                    title: const Text('Tentang Aplikasi'),
                    onTap: () {
                      // Navigasi ke halaman tentang aplikasi
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.blueAccent),
                    title: const Text('Pengaturan'),
                    onTap: () {
                      // Navigasi ke halaman pengaturan
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
