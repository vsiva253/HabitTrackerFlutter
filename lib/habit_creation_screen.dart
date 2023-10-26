import 'package:flutter/material.dart';

import 'habit.dart';

class HabitCreationScreen extends StatefulWidget {
  final Function(Habit)? onHabitCreated;

  HabitCreationScreen({required this.onHabitCreated});
  @override
  _HabitCreationScreenState createState() => _HabitCreationScreenState();
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController targetDaysController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String selectedFrequency = 'Every Day';
  String selectedTargetType = 'At Least';
  String selectedReminderOption = 'Off';
  TimeOfDay? reminderTime;
  TimeOfDay? selectedTime; // Store the selected time separately

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        reminderTime = picked; // Update reminderTime with the selected time
        selectedReminderOption = 'Select Time';
      });
    }
  }

  void _createHabit() {
    final name = nameController.text;
    final duration = int.tryParse(durationController.text) ?? 0;
    final question = questionController.text;
    final unit = unitController.text;
    final targetDays = int.tryParse(targetDaysController.text) ?? 0;
    final note = noteController.text;

    final habit = Habit(
      name: name,
      duration: duration,
      question: question,
      unit: unit,
      targetDays: targetDays,
      frequency: selectedFrequency,
      targetType: selectedTargetType,
      reminder: selectedReminderOption == 'Select Time'
          ? reminderTime ?? TimeOfDay.now()
          : TimeOfDay.now(),
      note: note,
    );
    if (widget.onHabitCreated != null) {
      widget.onHabitCreated!(habit);
    }
    Navigator.of(context)
        .pop(habit); // Pass the habit back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF0E0E0E), // Use #0E0E0E for app bar background
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "Create Habit",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(nameController, 'Habit Name'),
                SizedBox(height: 16),
                _buildTextField(durationController, 'Duration (days)'),
                SizedBox(height: 16),
                _buildTextField(questionController, 'Question'),
                SizedBox(height: 16),
                _buildTextField(unitController, 'Unit'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child:
                          _buildTextField(targetDaysController, 'Target Days'),
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        value: selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            selectedFrequency = value!;
                          });
                        },
                        items: <String>[
                          'Every Day',
                          'Every Week',
                          'Every Month'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Frequency'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTargetType,
                  onChanged: (value) {
                    setState(() {
                      selectedTargetType = value!;
                    });
                  },
                  items: <String>['At Least', 'At Most']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Target Type'),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Reminder: '),
                    DropdownButton<String>(
                      value: selectedReminderOption,
                      onChanged: (value) {
                        setState(() {
                          selectedReminderOption = value!;
                        });
                        if (value == 'Select Time') {
                          _selectTime();
                        }
                      },
                      items: ['Off', 'Select Time']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                if (selectedReminderOption == 'Select Time')
                  Row(
                    children: [
                      Text('Selected Time: '),
                      ElevatedButton(
                        onPressed: _selectTime,
                        child: Text(
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : 'Select Time',
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16),
                _buildTextField(noteController, 'Note (Optional)'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createHabit,
                  child: Text('Create Habit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
