import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'hotel_registration_kyc.dart';
import '../services/guest_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Column(
        children: [
          // --- COMPACT HEADER ---
          Container(
            padding: const EdgeInsets.fromLTRB(25, 50, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1e1e2d), Color(0xFF2d2d44)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white10,
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.blueAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Admin Console",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                      onPressed: () => _handleLogout(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat("Hotels", "12", Icons.business),
                    _buildStat("Alerts", "03", Icons.warning, isAlert: true),
                    _buildStat("Guests", "145", Icons.people),
                  ],
                ),
              ],
            ),
          ),
          // --- NAV GRID ---
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildCard(
                  context,
                  Icons.hotel,
                  "Hotels",
                  "Registered",
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllHotelsListScreen(),
                    ),
                  ),
                ),
                _buildCard(
                  context,
                  Icons.analytics,
                  "Guests",
                  "Live Data",
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HotelWiseGuestSelection(),
                    ),
                  ),
                ),
                _buildCard(
                  context,
                  Icons.pending_actions,
                  "KYC",
                  "Hotel Reg.",
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HotelRegistrationScreen(),
                    ),
                  ),
                ),
                _buildCard(
                  context,
                  Icons.security,
                  "Police",
                  "Alerts",
                  Colors.indigo,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FlaggedUsersScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    String label,
    String value,
    IconData icon, {
    bool isAlert = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isAlert ? Colors.orangeAccent : Colors.white54,
          size: 16,
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 9),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String title,
    String sub,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// --- SUB-SCREENS ---

class AllHotelsListScreen extends StatelessWidget {
  const AllHotelsListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final GuestService _service = GuestService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Hotels"),
        backgroundColor: const Color(0xFF1e1e2d),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _service.fetchGuestsRaw(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final data = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final h = data[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.hotel, color: Colors.white, size: 18),
                  ),
                  title: Text(
                    h['hotelName'] ?? "N/A",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Activity: ${h['checkIn'] ?? 'N/A'}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showDetails(context, "Hotel Report", [
                    _detailRow(Icons.business, "Hotel Name", h['hotelName']),
                    _detailRow(Icons.location_on, "Location", "Bhopal, MP"),
                    _detailRow(Icons.history, "Last Activity", h['checkIn']),
                    const Divider(height: 30),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      icon: const Icon(Icons.people, color: Colors.white),
                      label: const Text(
                        "VIEW HOTEL GUESTS",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelWiseGuestSelection(),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HotelWiseGuestSelection extends StatelessWidget {
  const HotelWiseGuestSelection({super.key});
  @override
  Widget build(BuildContext context) {
    final GuestService _service = GuestService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guest Monitoring"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _service.fetchGuestsRaw(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final data = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final g = data[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Text(
                      g['roomNumber']?.toString() ?? "0",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    g['guestName'] ?? "N/A",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Check-in: ${g['checkIn']}"),
                  onTap: () => _showDetails(context, "Guest Profile", [
                    _detailRow(Icons.person, "Name", g['guestName']),
                    _detailRow(
                      Icons.fingerprint,
                      "Aadhaar",
                      g['aadhaarNumber'],
                    ),
                    _detailRow(Icons.meeting_room, "Room No", g['roomNumber']),
                    _detailRow(Icons.phone, "Mobile", g['mobileNumber']),
                    _detailRow(Icons.login, "Check-In", g['checkIn']),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FlaggedUsersScreen extends StatelessWidget {
  const FlaggedUsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final GuestService _service = GuestService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Police System Alerts"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _service.fetchFlaggedGuests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final data = snapshot.data ?? [];
          if (data.isEmpty)
            return const Center(child: Text("System All Clear"));
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final g = data[index];
              return Card(
                color: Colors.red[50],
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.red.shade200),
                ),
                child: ListTile(
                  // FIXED: Now opens full details on click
                  onTap: () => _showDetails(context, "Police Security Alert", [
                    _detailRow(
                      Icons.warning,
                      "Alert Reason",
                      g['policeRemarks'],
                      color: Colors.red,
                    ),
                    _detailRow(Icons.hotel, "At Hotel", g['hotelName']),
                    _detailRow(Icons.person, "Guest Name", g['guestName']),
                    _detailRow(
                      Icons.fingerprint,
                      "Aadhaar No",
                      g['aadhaarNumber'],
                    ),
                    _detailRow(Icons.meeting_room, "Room", g['roomNumber']),
                    _detailRow(Icons.phone, "Mobile", g['mobileNumber']),
                    _detailRow(Icons.access_time, "Check-In", g['checkIn']),
                  ]),
                  leading: const Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: Text(
                    g['guestName'] ?? "Unknown",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: Text("Reason: ${g['policeRemarks']}"),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- SHARED UI HELPERS ---
void _showDetails(BuildContext context, String title, List<Widget> details) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1e1e2d),
            ),
          ),
          const Divider(height: 30),
          ...details,
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1e1e2d),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CLOSE REPORT",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _detailRow(
  IconData icon,
  String label,
  dynamic value, {
  Color color = Colors.indigo,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 15),
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value?.toString() ?? "N/A",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
