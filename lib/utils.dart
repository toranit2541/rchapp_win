import 'dart:convert';
import 'package:http/http.dart' as http;

class Event {
  final int id;
  final String title;
  final DateTime date;

  Event({required this.id, required this.title, required this.date});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
    );
  }
}

Future<List<Event>> fetchEvents() async {
  final response = await http.get(Uri.parse('http://<your-django-url>/api/events/'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((event) => Event.fromJson(event)).toList();
  } else {
    throw Exception('Failed to load events');
  }
}
