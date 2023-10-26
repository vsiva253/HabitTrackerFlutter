import 'package:demo/habit_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo/habit.dart';

// Rest of your code remains the same

void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatefulWidget {
  @override
  State<HabitTrackerApp> createState() => _HabitTrackerAppState();
}

class _HabitTrackerAppState extends State<HabitTrackerApp> {
  final List<Habit> habits = [];

  void addHabit(Habit habit) {
    // Add the habit to the list
    habits.add(habit);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF0E0E0E),
        ),
      ),
      home: MainScreen(habits: habits, onHabitAdded: addHabit),
    );
  }
}

class MainScreen extends StatefulWidget {
  final List<Habit> habits;
  final void Function(Habit) onHabitAdded;

  MainScreen({required this.habits, required this.onHabitAdded});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252525),
      appBar: AppBar(
        title: Text("Habits"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HabitCreationScreen(
                    onHabitCreated: (Habit newhabit) {
                      // Handle the newHabit object, e.g., add it to the list.
                      widget.onHabitAdded(newhabit);
                    },
                  ),
                ),
              );

              if (result != null) {
                // Call the callback to add the habit
                widget.onHabitAdded(result);
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            color: Color(0xFF252525),
            child: Row(
              children: [
                Expanded(child: Container()), // Empty space
                for (var i = 0; i < 5; i++)
                  Container(
                    width: 40.0,
                    height: 40.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateTime.now().add(Duration(days: i)).day.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _getDayName(
                              DateTime.now().add(Duration(days: i)).weekday),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var habit in widget.habits) HabitTile(habit),
          ],
        ),
      ),
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }
}

class HabitTile extends StatefulWidget {
  final Habit habit;

  HabitTile(this.habit);

  @override
  _HabitTileState createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    calculateProgress();
  }

  void calculateProgress() {
    final completedCount =
        widget.habit.completed.where((completed) => completed).length;
    progress = completedCount / widget.habit.totalDays;
  }

  void updateCompletion(int day, bool isCompleted) {
    setState(() {
      widget.habit.completed[day] = isCompleted;
      calculateProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Card(
            color: Color(0xFF373737),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value: progress,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.habit.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++)
                          HabitDayTile(
                            isCompleted: widget.habit.completed[i],
                            updateCompletion: (isCompleted) {
                              updateCompletion(i, isCompleted);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HabitDayTile extends StatefulWidget {
  bool isCompleted;
  Function(bool) updateCompletion;

  HabitDayTile({
    required this.isCompleted,
    required this.updateCompletion,
  });

  @override
  _HabitDayTileState createState() => _HabitDayTileState();
}

class _HabitDayTileState extends State<HabitDayTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool updatedCompletion = !widget.isCompleted;
        widget.updateCompletion(updatedCompletion);

        setState(() {
          widget.isCompleted = updatedCompletion;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Icon(
            widget.isCompleted ? Icons.check : Icons.close,
            color: widget.isCompleted ? Colors.green : Colors.white12,
            size: 24,
          ),
        ],
      ),
    );
  }
}
