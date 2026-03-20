import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/guest_service.dart';

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({super.key});

  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard> {
  final GuestService _service = GuestService();
  String _searchQuery = "";

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // Guest Details Bottom Sheet
  void _showGuestDetails(BuildContext context, dynamic g) {
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
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Official Security Report",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const Divider(height: 25),
            _infoTile(
              Icons.report,
              "Alert Reason",
              g['policeRemarks'] ?? "N/A",
              color: Colors.red,
            ),
            _infoTile(Icons.hotel, "Stayed At", g['hotelName'] ?? 'N/A'),
            _infoTile(Icons.person, "Guest Name", g['guestName']),
            _infoTile(Icons.fingerprint, "Aadhaar", g['aadhaarNumber']),
            _infoTile(Icons.phone_android, "Mobile", g['mobileNumber']),
            _infoTile(Icons.history, "Check-In", g['checkInTime'] ?? 'N/A'),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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

  Widget _infoTile(
    IconData icon,
    String label,
    String value, {
    Color color = Colors.indigo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Column(
        children: [
          // --- NORMAL HEIGHT HEADER ---
          Container(
            padding: const EdgeInsets.fromLTRB(25, 50, 20, 15),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF283593)],
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
                        Icons.security,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Police Monitoring",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "LIVE SURVEILLANCE",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickStat("Live", "24", Icons.people_outline),
                    _buildQuickStat(
                      "Alerts",
                      "03",
                      Icons.warning_amber_rounded,
                      isAlert: true,
                    ),
                    _buildQuickStat("Hotels", "12", Icons.business_outlined),
                  ],
                ),
              ],
            ),
          ),

          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                onChanged: (val) =>
                    setState(() => _searchQuery = val.toLowerCase()),
                decoration: const InputDecoration(
                  hintText: "Search Name or Aadhaar...",
                  prefixIcon: Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // --- GUEST LIST (Using Flagged Guests Endpoint) ---
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _service
                  .fetchFlaggedGuests(), // Calling the flagged endpoint
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());

                final data = snapshot.data ?? [];
                final filtered = data
                    .where(
                      (g) =>
                          g['guestName'].toString().toLowerCase().contains(
                            _searchQuery,
                          ) ||
                          g['aadhaarNumber'].toString().contains(_searchQuery),
                    )
                    .toList();

                if (filtered.isEmpty)
                  return const Center(child: Text("System Status: All Clear"));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final g = filtered[index];
                    return Card(
                      color: Colors.red[50],
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: ListTile(
                        dense: true,
                        onTap: () => _showGuestDetails(context, g),
                        leading: const Icon(Icons.warning, color: Colors.red),
                        title: Text(
                          g['guestName'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Hotel: ${g['hotelName']}\nReason: ${g['policeRemarks']}",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
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
        const SizedBox(width: 6),
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
}
