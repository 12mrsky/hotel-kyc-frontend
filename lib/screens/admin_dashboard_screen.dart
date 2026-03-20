import 'package:flutter/material.dart';
import '../services/guest_service.dart';
import '../models/guest_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GuestService _service = GuestService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text("HOTEL ADMIN", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF0F2027),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Guest>>(
        future: _service.fetchGuests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          }

          final guests = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Dashboard Stats Cards
                  Row(
                    children: [
                      _buildSummaryCard("Total Bookings", guests.length.toString(), Colors.blue, Icons.hotel),
                      const SizedBox(width: 12),
                      _buildSummaryCard("Today's Guests", guests.where((g) => g.createdAt.day == DateTime.now().day).length.toString(), Colors.green, Icons.today),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Recent Registrations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),

                  // Updated Data List - Simplified for scanning names
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: guests.length,
                    itemBuilder: (context, index) {
                      final guest = guests[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          leading: Hero(
                            tag: 'room-${guest.id}', // Hero animation tag
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: Text(guest.roomNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            ),
                          ),
                          title: Text(
                            guest.guestName, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          onTap: () {
                            // Navigation to the detail view
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GuestDetailScreen(guest: guest),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 15),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// --- Detailed Screen Section ---

class GuestDetailScreen extends StatelessWidget {
  final Guest guest;
  const GuestDetailScreen({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text("GUEST PROFILE"),
        backgroundColor: const Color(0xFF0F2027),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header with Hero Animation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF0F2027),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Hero(
                    tag: 'room-${guest.id}',
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Text(guest.roomNumber, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(guest.guestName, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                  const Text("KYC Verified", style: TextStyle(color: Colors.greenAccent, letterSpacing: 1.2)),
                ],
              ),
            ),
            
            // Detailed Info Cards
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _infoTile(Icons.fingerprint, "Aadhaar Card", guest.aadhaarNumber),
                    _infoTile(Icons.phone_android, "Mobile Number", guest.mobileNumber),
                    _infoTile(Icons.people_outline, "Adults / Kids", "${guest.adults} Adults, ${guest.kids} Kids"),
                    _infoTile(Icons.calendar_today, "Stay Dates", "${guest.checkInTime} to ${guest.checkOutTime}"),
                    _infoTile(Icons.history, "Registered On", guest.createdAt.toString().split('.')[0]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 28),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF203A43))),
    );
  }
}