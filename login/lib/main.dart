import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() => runApp(TaskManagerApp());

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  bool isDone;
  final List<ChecklistItem> checklist;
  final List<String> notes;
  String instagramStatus;
  String facebookStatus;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isDone = false,
    this.checklist = const [],
    this.notes = const [],
    this.instagramStatus = 'Inativo',
    this.facebookStatus = 'Inativo',
  });
}

class ChecklistItem {
  final String text;
  bool isCompleted;

  ChecklistItem({required this.text, this.isCompleted = false});
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager App',
      home: TaskManagerHomePage(),
    );
  }
}

class TaskManagerHomePage extends StatefulWidget {
  @override
  _TaskManagerHomePageState createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedInstagramStatus = 'Inativo';
  String _selectedFacebookStatus = 'Inativo';
  List<Task> _tasks = [];

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _tasks.add(Task(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate!,
          instagramStatus: _selectedInstagramStatus,
          facebookStatus: _selectedFacebookStatus,
        ));
        _titleController.clear();
        _descriptionController.clear();
        _selectedDate = null;
        _selectedInstagramStatus = 'Inativo';
        _selectedFacebookStatus = 'Inativo';
        _saveToExcel(_tasks);
      });
    }
  }

  Future<void> _saveToExcel(List<Task> tasks) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow([
      'Title',
      'Description',
      'Due Date',
      'Status Instagram',
      'Status Facebook',
    ]);

    for (var task in tasks) {
      sheet.appendRow([
        task.title,
        task.description,
        DateFormat('dd/MM/yyyy').format(task.dueDate),
        task.instagramStatus,
        task.facebookStatus,
      ]);
    }

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final String excelFilePath = '$appDocPath/tasks.xlsx';

    final file = File(excelFilePath);
    await file.create(recursive: true);


    print('Data saved to Excel file: $excelFilePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager App'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'FILIAL:'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'O título é obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Oferta do dia '),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Data De Postagem'),
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedInstagramStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedInstagramStatus = newValue!;
                      });
                    },
                    items: <String>['Postado', 'Inativo', 'Atrasado']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: _selectedFacebookStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFacebookStatus = newValue!;
                      });
                    },
                    items: <String>[' Postado', 'Inativo', 'Atrasado']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: Text('Adicionar Tarefa'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _saveToExcel(_tasks);
                    },
                    child: Text('Salvar para Excel'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tarefas Futuras:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            if (_tasks.isEmpty)
              Text('Nenhuma tarefa futura adicionada.'),
            for (Task task in _tasks)
              if (task.dueDate.isAfter(DateTime.now()))
                TaskCard(
                  task: task,
                  onDelete: () {
                    setState(() {
                      _tasks.remove(task);
                      _saveToExcel(_tasks);
                    });
                  },
                ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;

  TaskCard({required this.task, required this.onDelete});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.task.title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    widget.onDelete();
                  },
                ),
              ],
            ),
            Text(
              'Descrição: ${widget.task.description}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Data de Vencimento: ${DateFormat('dd/MM/yyyy').format(widget.task.dueDate)}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Status Instagram: ${widget.task.instagramStatus}',
              style: TextStyle(
                fontSize: 16.0,
                color: _getStatusColor(widget.task.instagramStatus),
              ),
            ),
            Text(
              'Status Facebook: ${widget.task.facebookStatus}',
              style: TextStyle(
                fontSize: 16.0,
                color: _getStatusColor(widget.task.facebookStatus),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Postado') {
      return Colors.green;
    } else if (status == 'Atrasado') {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
}
