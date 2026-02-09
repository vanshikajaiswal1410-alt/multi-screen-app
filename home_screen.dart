import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_screen.dart';
import 'profile_screen.dart';
import '../theme_provider.dart';

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> tasks = [];
  List<String> completed = []; // completed tasks ke titles
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ?? [];
      completed = prefs.getStringList('completed') ?? [];
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
    await prefs.setStringList('completed', completed);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildTaskPage(),
      ProfileScreen(themeProvider: widget.themeProvider),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Smart Planner")),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskScreen()),
                );

                if (result != null && result.toString().isNotEmpty) {
                  setState(() {
                    tasks.add(result);
                  });
                  saveData();
                }
              },
            )
          : null,
    );
  }

  Widget buildTaskPage() {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks yet 🚀",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
     return ListView.builder(
  itemCount: tasks.length,
  itemBuilder: (context, index) {
    final task = tasks[index];
    final isDone = completed.contains(task);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                completed.add(task);
              } else {
                completed.remove(task);
              }
            });
            saveData();
          },
        ),
        title: Text(
          task,
          style: TextStyle(
            decoration:
                isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              completed.remove(task);
              tasks.removeAt(index);
            });
            saveData();
          },
        ),
      ),
    );
  },
);
  }
}