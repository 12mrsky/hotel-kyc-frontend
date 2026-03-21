import 'package:flutter/material.dart';
import '../services/guest_service.dart';
import '../models/guest_model.dart';
import 'guest_detail_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GuestService _service = GuestService();
  late Future<List<Guest>> _guestFuture;

  @override
  void initState() {
    super.initState();
    _loadGuests();
  }

  void _loadGuests() {
    _guestFuture = _service.fetchGuests();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadGuests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text("HOTEL ADMIN"),
        backgroundColor: const Color(0xFF0F2027),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Guest>>(
        future: _guestFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final guests = snapshot.data ?? [];

          // ✅ Today filter FIX
          final todayGuests = guests.where((g) {
            final now = DateTime.now();
            return g.createdAt.year == now.year &&
                g.createdAt.month == now.month &&
                g.createdAt.day == now.day;
          }).toList();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: guests.isEmpty
                ? const Center(child: Text("No Guests Found"))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _card("Total", guests.length.toString(), Colors.blue),
                            const SizedBox(width: 10),
                            _card("Today", todayGuests.length.toString(), Colors.green),
                          ],
                        ),
                        const SizedBox(height: 20),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Guest List",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),

                        const SizedBox(height: 10),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: guests.length,
                          itemBuilder: (context, index) {
                            final g = guests[index];

                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(g.roomNumber),
                                ),
                                title: Text(g.guestName),
                                subtitle: Text(g.mobileNumber),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GuestDetailScreen(guest: g),
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

  Widget _card(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(value,
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(title),
          ],
        ),
      ),
    );
  }
}