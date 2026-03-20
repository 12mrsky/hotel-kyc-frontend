import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'guest_registration_screen.dart';
import 'admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final String fullName;
  final String email;

  const HomeScreen({super.key, required this.fullName, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOtherKYCView = false;

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
      // --- FIXED SOS BUTTON (Using FAB to avoid overlap) ---
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          onPressed: () => _showPoliceEmergencyDialog(context),
          backgroundColor: const Color(0xFFFF5252),
          icon: const Icon(Icons.emergency, color: Colors.white),
          label: const Text(
            "POLICE SOS",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SHARED HEADER ---
          Container(
            padding: const EdgeInsets.fromLTRB(25, 60, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1e1e2d), Color(0xFF2d2d44)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                if (_isOtherKYCView)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => setState(() => _isOtherKYCView = false),
                  )
                else
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white10,
                    child: Text(
                      widget.fullName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isOtherKYCView
                            ? "Verification Hub"
                            : "Property Manager,",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _isOtherKYCView
                            ? "Other KYC Services"
                            : widget.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.power_settings_new,
                    color: Color(0xFFFF5252),
                  ),
                  onPressed: () => _handleLogout(context),
                ),
              ],
            ),
          ),

          // --- MAIN CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // Space for SOS FAB
              child: _isOtherKYCView
                  ? _buildOtherKYCContent()
                  : _buildMainDashboardContent(),
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. MAIN MANAGEMENT VIEW ---
  Widget _buildMainDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox("08", "Today", Icons.login, Colors.blue),
              _buildStatBox(
                "02",
                "Flagged",
                Icons.warning_amber_rounded,
                Colors.orange,
              ),
              _buildStatBox(
                "Secure",
                "Status",
                Icons.verified_user,
                Colors.green,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
          child: Text(
            "Main Management",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D44),
            ),
          ),
        ),
        GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: [
            _buildCard(
              Icons.person_add_alt_1,
              "Guest KYC",
              "New Check-In",
              Colors.blueAccent,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GuestRegistrationScreen(),
                ),
              ),
            ),

            _buildHotelPanelCard(), // Updated Hotel Panel Design

            _buildCard(
              Icons.assignment_ind,
              "Other KYC",
              "Biometric Services",
              Colors.orange,
              () => setState(() => _isOtherKYCView = true),
            ),

            _buildCard(
              Icons.admin_panel_settings,
              "Police Login",
              "Official Details",
              Colors.indigo,
              () => _showPoliceLoginDetail(),
            ),
          ],
        ),
      ],
    );
  }

  // --- 2. OTHER KYC VIEW ---
  Widget _buildOtherKYCContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select KYC Method",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D44),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildCard(
                Icons.qr_code_scanner,
                "Aadhaar QR",
                "Scan QR Code",
                Colors.orange,
                () => _showToast("Starting Aadhaar Scanner..."),
              ),
              _buildCard(
                Icons.fingerprint,
                "Fingerprint",
                "Thumb Scan",
                Colors.blue,
                () => _showToast("Place finger on scanner"),
              ),
              _buildCard(
                Icons.face_unlock_outlined,
                "Biometric",
                "Facial / Iris",
                Colors.purple,
                () => _showToast("Initializing Face ID..."),
              ),
              _buildCard(
                Icons.edit_document,
                "Manual KYC",
                "Doc Upload",
                Colors.teal,
                () => _showToast("Upload Documents Manually"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3. UPDATED HOTEL PANEL CARD ---
  Widget _buildHotelPanelCard() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade400, Colors.indigo.shade700],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.grid_view_rounded, size: 35, color: Colors.white),
            const SizedBox(height: 10),
            const Text(
              "Hotel Panel",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              "Property Controls",
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. POLICE SOS DIALOG ---
  void _showPoliceEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Column(
          children: [
            Icon(Icons.emergency_share, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text(
              "EMERGENCY SOS",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Instant help via official channels:"),
            const SizedBox(height: 20),
            _buildEmergencyContact("Police Control Room", "100", Colors.blue),
            _buildEmergencyContact("National Help Line", "112", Colors.indigo),
            _buildEmergencyContact("Women Help Line", "1090", Colors.purple),
            const SizedBox(height: 15),
            const Text(
              "Your location & guest logs will be shared with the station.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CONFIRM SIGNAL",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact(String title, String number, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. POLICE LOGIN DETAIL POPUP ---
  void _showPoliceLoginDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
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
            const Icon(Icons.security, size: 50, color: Color(0xFF1e1e2d)),
            const SizedBox(height: 15),
            const Text(
              "Official Police Portal",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            const ListTile(
              leading: Icon(Icons.badge, color: Colors.indigo),
              title: Text("Station ID"),
              subtitle: Text("PS-BHOPAL-ZONE1-01"),
            ),
            const ListTile(
              leading: Icon(Icons.history, color: Colors.indigo),
              title: Text("Last Sync"),
              subtitle: Text("Today, 02:00 AM"),
            ),
            const SizedBox(height: 20),
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
                "CLOSE",
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

  // --- UI HELPERS ---
  Widget _buildStatBox(String val, String label, IconData icon, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 5),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildCard(
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
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2d2d44),
      ),
    );
  }
}
