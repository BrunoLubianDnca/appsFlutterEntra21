import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(TaskManagerApp());

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  bool isDone;
  final List<ChecklistItem> checklist;
  final List<String> notes;
  String statusInstagram;
  String statusFacebook;
  String statusWhatsappTalk;
  String filial; // Adicionado o campo de filial

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isDone = false,
    this.checklist = const [],
    this.notes = const [],
    this.statusInstagram = 'Inativo',
    this.statusFacebook = 'Inativo',
    this.statusWhatsappTalk = 'Inativo',
    required this.filial,
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
      title: 'Gerenciador de Tarefas',
      home: TaskManagerHomePage(),
    );
  }
}

class TaskManagerHomePage extends StatefulWidget {
  @override
  _TaskManagerHomePageState createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  int _currentOfferIndex = 0;

  List<Map<String, dynamic>> offerDates = [
    {'description': 'Segunda da Limpeza e da Higiene', 'date': DateTime(2023, 10, 30)},
    {'description': 'Terça do Hortifrúti', 'date': DateTime(2023, 10, 31)},
    {'description': 'Quarta do Hortifrúti', 'date': DateTime(2023, 11, 1)},
    {'description': 'Ofertas da Quinta Frios e Frango', 'date': DateTime(2023, 11, 2)},
    {'description': 'Sexta das Carnes ', 'date': DateTime(2023, 11, 3)},
    {'description': 'Fim De Semana Especial', 'date': DateTime(2023, 11, 4)},
    {'description': 'Fim De Semana Especial', 'date': DateTime(2023, 11, 5)},
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedStatusInstagram = 'Inativo';
  String _selectedStatusFacebook = 'Inativo';
  String _selectedStatusWhatsappTalk = 'Inativo';
  String _selectedFilial = 'BLUMENAU'; // Inicialmente definido para a filial "BLUMENAU"

  List<Task> _tasks = [];

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _tasks.add(Task(
          title: offerDates[_currentOfferIndex]['description'],
          description: _descriptionController.text,
          dueDate: _selectedDate!,
          statusInstagram: _selectedStatusInstagram,
          statusFacebook: _selectedStatusFacebook,
          statusWhatsappTalk: _selectedStatusWhatsappTalk,
          filial: _selectedFilial, // Define a filial selecionada
        ));

        _descriptionController.clear();
        _selectedDate = null;

        // Avançar para a próxima oferta com base na data selecionada
        if (_selectedDate != null) {
          int selectedDayOfWeek = _selectedDate!.weekday;
          if (selectedDayOfWeek >= DateTime.monday && selectedDayOfWeek <= DateTime.friday) {
            _currentOfferIndex = selectedDayOfWeek - DateTime.monday;
            _selectedStatusInstagram = 'Inativo';
            _selectedStatusFacebook = 'Inativo';
            _selectedStatusWhatsappTalk = 'Inativo';
          }
        }
      });
    }
  }

  String? _validateDate(DateTime? date) {
    if (date == null) {
      return 'Selecione uma data';
    }
    if (date.isBefore(DateTime.now())) {
      return 'Selecione uma data futura';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Controle De Postagem Mkt')),backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Image.asset('assets/app.jpeg'),
              ],
            ) ,
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: _selectedFilial,
                    decoration: InputDecoration(labelText: 'FILIAL:'),
                    items: [
                      'BLUMENAU',
                      ' SUPER ÁGUA VERDE',
                      ' SUPER GARCIA',
                      ' SUPER GLÓRIA',
                      ' SUPER ITOUPAVA NORTE',
                      ' SUPER MAFISA',
                      ' SUPER OMINO',
                      ' SUPER VILA NOVA',
                      ' SUPER CENTRO',
                      ' SUPER NAÇÕES',
                      'SUPER JARAGUÁ DO SUL',
                      ' SUPER ÁGUA VERDE',
                      ' SUPER BARRA',
                      ' SUPER VILA NOVA',
                      ' FRESH CENTRO',
                      'ATACAREJO ILHA DA FIGUEIRA ',
                      ' MINI GASPAR',
                      ' SUPER IBIRAMA',
                      ' ATACAREJO JOINVILLE',
                      ' SUPER RODEIO',
                      ' SUPER TIMBÓ',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilial = newValue!;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Data de Postagem'),
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        initialDatePickerMode: DatePickerMode.day,
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            // Avançar para a próxima oferta com base na data selecionada
                            int selectedDayOfWeek = pickedDate.weekday;
                            if (selectedDayOfWeek >= DateTime.monday && selectedDayOfWeek <= DateTime.sunday) {
                              _currentOfferIndex = selectedDayOfWeek - DateTime.monday;
                              _selectedStatusInstagram = 'Inativo';
                              _selectedStatusFacebook = 'Inativo';
                              _selectedStatusWhatsappTalk = 'Inativo';
                            }
                          });
                        }
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedStatusInstagram,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatusInstagram = newValue!;
                      });
                    },
                    items: <String>['Postado', 'Inativo', 'Atrasado']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Text('Instagram: '),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: _selectedStatusFacebook,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatusFacebook = newValue!;
                      });
                    },
                    items: <String>['Postado', 'Inativo', 'Atrasado']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Text('Facebook: '),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: _selectedStatusWhatsappTalk,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatusWhatsappTalk = newValue!;
                      });
                    },
                    items: <String>['Ativo', 'Inativo', 'Atrasado']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Text('WhatsappTalk: '),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: Text ('Adicionar Rotina'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Lembretes:',
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
              'Status Instagram: ${widget.task.statusInstagram}',
              style: TextStyle(
                fontSize: 16.0,
                color: _getStatusColor(widget.task.statusInstagram),
              ),
            ),
            Text(
              'Status Facebook: ${widget.task.statusFacebook}',
              style: TextStyle(
                fontSize: 16.0,
                color: _getStatusColor(widget.task.statusFacebook),
              ),
            ),
            Text(
              'Status WhatsApp Talk: ${widget.task.statusWhatsappTalk}',
              style: TextStyle(
                fontSize: 16.0,
                color: _getStatusColor(widget.task.statusWhatsappTalk),
              ),
            ),
            Text(
              'Filial: ${widget.task.filial}', // Adicionado campo de filial
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            if (widget.task.notes.isNotEmpty)
              Text(
                'Notas:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            for (String note in widget.task.notes)
              Text(
                '- $note',
                style: TextStyle(fontSize: 16.0),
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
    } else if (status == 'Ativo') {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }
}
