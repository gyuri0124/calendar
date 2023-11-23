import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('ko_KR');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    focusedDay =
                        DateTime(focusedDay.year, focusedDay.month - 1);
                  });
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showYearMonthSelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      DateFormat.yMMMM('ko_KR').format(focusedDay),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: "JetBrainsMono-Regular",
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(), // 오른쪽 Spacer 추가
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() {
                    focusedDay =
                        DateTime(focusedDay.year, focusedDay.month + 1);
                  });
                },
              ),
            ],
          ),
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(1950, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: focusedDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            headerVisible: false,
          ),
        ],
      ),
    );
  }

  void _showYearMonthSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: YearMonthSelector(
              onYearMonthSelected: (int year, int month) {
                Navigator.of(context).pop();
                setState(() {
                  focusedDay = DateTime(year, month);
                });
              },
            ),
          ),
        );
      },
    );
  }
}

class YearMonthSelector extends StatelessWidget {
  final List<int> years = List.generate(100, (index) => 1950 + index);
  final List<String> months = List.generate(12, (index) => "${index + 1}월");
  final Function(int year, int month) onYearMonthSelected;

  YearMonthSelector({Key? key, required this.onYearMonthSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: years.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${years[index]}년"),
                onTap: () {
                  onYearMonthSelected(years[index], DateTime.now().month);
                },
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: months.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(months[index]),
                onTap: () {
                  onYearMonthSelected(DateTime.now().year, index + 1);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
