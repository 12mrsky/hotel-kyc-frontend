class HotelRegistrationModel {
  final String hotelName;
  final String ownerName;
  final String gstNumber;
  final String address;
  final String email;
  final String mobile;
  final String hotelType; // e.g., 3-Star, Resort, Normal

  HotelRegistrationModel({
    required this.hotelName,
    required this.ownerName,
    required this.gstNumber,
    required this.address,
    required this.email,
    required this.mobile,
    required this.hotelType,
  });

  Map<String, dynamic> toJson() {
    return {
      'hotelName': hotelName,
      'ownerName': ownerName,
      'gstNumber': gstNumber,
      'address': address,
      'email': email,
      'mobile': mobile,
      'hotelType': hotelType,
    };
  }
}
