class Guest {
  final int id;
  final String roomNumber;
  final String guestName;
  final String checkInTime;
  final String checkOutTime;
  final int adults;
  final int kids;
  final String aadhaarNumber;
  final String mobileNumber;
  final DateTime createdAt;

  Guest({
    required this.id,
    required this.roomNumber,
    required this.guestName,
    required this.checkInTime,
    required this.checkOutTime,
    required this.adults,
    required this.kids,
    required this.aadhaarNumber,
    required this.mobileNumber,
    required this.createdAt,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      roomNumber: json['roomNumber'] ?? '',
      guestName: json['guestName'] ?? '',
      checkInTime: json['checkInTime'] ?? '',
      checkOutTime: json['checkOutTime'] ?? '',
      adults: json['adults'] ?? 0,
      kids: json['kids'] ?? 0,
      aadhaarNumber: json['aadhaarNumber'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
