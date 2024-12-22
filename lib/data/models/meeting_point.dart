class MeetingPoint {
  double lat;
  double long;
  DateTime data;

  MeetingPoint({
    required this.lat,
    required this.long,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
      'data': data.toIso8601String(),
    };
  }

  factory MeetingPoint.fromJson(Map<String, dynamic> json) {
    return MeetingPoint(
      lat: json['lat'],
      long: json['long'],
      data: DateTime.parse(json['data']),
    );
  }
}
