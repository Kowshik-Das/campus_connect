class ClassSchedule {
  final String id;
  final String day;
  final String className;
  final String facultyInitial;
  final String time;
  final String room;

  ClassSchedule({
    required this.id,
    required this.day,
    required this.className,
    required this.facultyInitial,
    required this.time,
    required this.room,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'className': className,
      'facultyInitial': facultyInitial,
      'time': time,
      'room': room,
    };
  }

  factory ClassSchedule.fromMap(String id, Map<String, dynamic> map) {
    return ClassSchedule(
      id: id,
      day: map['day'] ?? '',
      className: map['className'] ?? '',
      facultyInitial: map['facultyInitial'] ?? '',
      time: map['time'] ?? '',
      room: map['room'] ?? '',
    );
  }
}
