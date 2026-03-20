import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/guest_service.dart';

class GuestRegistrationScreen extends StatefulWidget {
  const GuestRegistrationScreen({super.key});

  @override
  State<GuestRegistrationScreen> createState() => _GuestRegistrationScreenState();
}

class _GuestRegistrationScreenState extends State<GuestRegistrationScreen> {
  // Stay Details Controllers
  final _roomController = TextEditingController();
  final _guestNameController = TextEditingController();
  final _checkInController = TextEditingController(text: "29-12-2025 12:15");
  final _checkOutController = TextEditingController(text: "31-12-2025 12:15");
  final _adultsController = TextEditingController(text: "2");
  final _kidsController = TextEditingController();

  // Personal & KYC Controllers
  final _aadhaarController = TextEditingController(); 
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _comingFromController = TextEditingController();
  final _goingToController = TextEditingController();

  // --- SERVICE INTEGRATION ---
  final _guestService = GuestService(); 
  bool _isSaving = false;

  void _handleFinalSubmit() async {
    setState(() => _isSaving = true);

    final guestData = {
      "roomNumber": _roomController.text,
      "guestName": _guestNameController.text,
      "checkInTime": _checkInController.text,
      "checkOutTime": _checkOutController.text,
      "adults": int.tryParse(_adultsController.text) ?? 1,
      "kids": int.tryParse(_kidsController.text) ?? 0,
      "aadhaarNumber": _aadhaarController.text,
      "age": int.tryParse(_ageController.text) ?? 0,
      "mobileNumber": _mobileController.text,
      "address": _addressController.text,
      "comingFrom": _comingFromController.text,
      "goingTo": _goingToController.text,
    };

    try {
      final response = await _guestService.registerGuest(guestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Success! Guest Registered."), backgroundColor: Colors.green),
          );
          Navigator.pop(context); 
        }
      } else {
        print("Server Response Body: ${response.body}");
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- UI WIDGETS ---

  Future<void> _launchAadhaarURL() async {
    final Uri url = Uri.parse('https://myaadhaar.uidai.gov.in/check-aadhaar-validity/en');
    try {
      await launchUrl(url, mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(enableJavaScript: true, enableDomStorage: true),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        elevation: 0,
        title: const Text("REGISTRATION", style: TextStyle(letterSpacing: 1.5, fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F2027),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF0F2027),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Guest Registration Form", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Verify Aadhaar and save guest details", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("STAY DETAILS"),
                    const SizedBox(height: 15),
                    _buildRow(
                      _buildField("Room Number *", _roomController, icon: Icons.meeting_room_outlined),
                      _buildField("Guest Name *", _guestNameController, icon: Icons.person_outline),
                    ),
                    const SizedBox(height: 15),
                    _buildRow(
                      _buildField("Check-in Time *", _checkInController, icon: Icons.login_outlined),
                      _buildField("Check-out Time *", _checkOutController, icon: Icons.logout_outlined),
                    ),
                    const SizedBox(height: 15),
                    _buildRow(
                      _buildField("Adults *", _adultsController, icon: Icons.group_outlined, isNumeric: true),
                      _buildField("Kids", _kidsController, icon: Icons.child_care_outlined, isNumeric: true),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(thickness: 1, color: Color(0xFFEEEEEE))),
                    _buildSectionTitle("KYC & PERSONAL INFO"),
                    const SizedBox(height: 15),
                    _buildField("Aadhaar Card Number *", _aadhaarController, icon: Icons.fingerprint, isNumeric: true),
                    const SizedBox(height: 15),
                    _buildRow(
                      _buildField("Age", _ageController, isNumeric: true),
                      _buildField("Mobile *", _mobileController, icon: Icons.phone_android_outlined, isNumeric: true),
                    ),
                    const SizedBox(height: 15),
                    _buildField("Current Address", _addressController, maxLines: 2),
                    const SizedBox(height: 15),
                    _buildRow(_buildField("Coming From", _comingFromController), _buildField("Going To", _goingToController)),
                    const SizedBox(height: 30),
                    
                    _buildActionButton(
                      label: "GENERATE KYC LINK",
                      color: const Color(0xFF4A90E2),
                      icon: Icons.verified_user_outlined,
                      onPressed: _launchAadhaarURL,
                    ),
                    const SizedBox(height: 15),
                    
                    // SAVE BUTTON
                    _buildActionButton(
                      label: _isSaving ? "SAVING..." : "FINAL SUBMIT",
                      color: const Color(0xFF28A745),
                      icon: _isSaving ? Icons.hourglass_top : Icons.cloud_done_outlined,
                      onPressed: _isSaving ? () {} : _handleFinalSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.1));
  }

  Widget _buildRow(Widget left, Widget right) {
    return Row(children: [Expanded(child: left), const SizedBox(width: 12), Expanded(child: right)]);
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1, IconData? icon, bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF203A43))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0F4F8),
            suffixIcon: icon != null ? Icon(icon, size: 18, color: const Color(0xFF203A43)) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required String label, required Color color, required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}