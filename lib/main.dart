import 'package:flutter/material.dart';

void main(){
  runApp(const MaterialApp(home: MyApp(),debugShowCheckedModeBanner: false,));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<int> get _visibleIndexes {
    if (!_isSearching || _searchController.text.trim().isEmpty) {
      // show all indexes
      return List<int>.generate(notes.length, (i) => i);
    }
    final q = _searchController.text.trim().toLowerCase();
    return List<int>.generate(notes.length, (i) => i).where((i) {
      final title = (notes[i]['title'] ?? '').toLowerCase();
      return title.contains(q);
    }).toList();
  }
  
  List<Map<String, String>> notes = [
  {'title': 'Buy groceries', 'content': 'Milk, Bread, Eggs'},
  {'title': 'Meeting', 'content': 'Zoom call at 5 PM'},
  {'title': 'Flutter project', 'content': 'Work on ListView UI'},
  ];

  void deleteNote(int index){
    setState(() {
      notes.removeAt(index);
    });
  }

  void onReorder(int oldIndex, int newIndex){
    setState(() {
      if(newIndex > oldIndex) newIndex--;
      final item = notes.removeAt(oldIndex);
      notes.insert(newIndex, item);
    });
  }

  void editNote(int index) {
    // Get current note
    final note = notes[index];

    // Controllers to hold temporary text input
    final titleController = TextEditingController(text: note['title']);
    final contentController = TextEditingController(text: note['content']);

    // Show a simple AlertDialog with TextFields
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // cancel
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notes[index]['title'] = titleController.text;
                  notes[index]['content'] = contentController.text;
                });
                Navigator.pop(context); // close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void addNote(){
    setState(() {
      notes.add({"title":"new note","content":"Hello"});
      editNote(notes.length-1);
    });

  }

  @override
Widget build(BuildContext context) {
  final visible = _visibleIndexes; // your computed filtered indexes

  return Scaffold(
    appBar: AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Поиск по заголовку…',
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}), // live filter
            )
          : const Text('Ваши заметки'),
      actions: [
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() => _isSearching = false);
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => setState(() => _isSearching = true),
          ),
      ],
    ),

    body: Center(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: _isSearching
                // --- SEARCH MODE: plain ListView + Dismissible ---
                ? ListView.builder(
                    itemCount: visible.length,
                    itemBuilder: (context, idx) {
                      final i = visible[idx];
                      final note = notes[i];

                      // Key must be unique and stable. Prefer an ID if you have one.
                      final itemKey = ValueKey('note-search-$i');

                      return Dismissible(
                        key: itemKey, // top-level child is the Dismissible
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => deleteNote(i),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          child: ListTile(
                            title: Text(note['title'] ?? ''),
                            subtitle: Text(note['content'] ?? ''),
                            leading: const Icon(Icons.note),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteNote(i), // use original index
                            ),
                            onTap: () => editNote(i),
                          ),
                        ),
                      );
                    },
                  )
                // --- NORMAL MODE: Reorderable + Dismissible ---
                : ReorderableListView.builder(
                    itemCount: notes.length,
                    onReorder: onReorder,
                    buildDefaultDragHandles: true, // keep default long-press drag
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      // This key identifies the *reorderable item*. Put it on Dismissible.
                      final itemKey = ValueKey('note-$index');

                      return Dismissible(
                        key: itemKey, // Reorderable uses this as the child's key
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => deleteNote(index),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          child: ListTile(
                            title: Text(note['title'] ?? ''),
                            subtitle: Text(note['content'] ?? ''),
                            leading: const Icon(Icons.note),
                            trailing: IconButton(
                              onPressed: () => deleteNote(index),
                              icon: const Icon(Icons.delete),
                            ),
                            onTap: () => editNote(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),

    floatingActionButton: FloatingActionButton.extended(
      onPressed: addNote,
      label: const Text('Добавить заметку'),
      icon: const Icon(Icons.add),
    ),
  );
}


}