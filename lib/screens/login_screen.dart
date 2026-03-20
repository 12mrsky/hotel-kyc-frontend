import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import '../widgets/wave_painter.dart';
import 'admin_dashboard.dart';
import 'police_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("Please enter credentials");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _authService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Role extraction and cleaning
        String userRole = (data['role'] ?? data['Role'] ?? 'hotel')
            .toString()
            .toLowerCase()
            .trim();

        if (mounted) {
          Widget nextScreen;

          // Role-based Routing Logic
          if (userRole == 'admin') {
            nextScreen = const AdminDashboard();
          } else if (userRole == 'police') {
            nextScreen = const PoliceDashboard();
          } else {
            nextScreen = HomeScreen(
              fullName: data['fullName'] ?? "User",
              email: data['email'] ?? "",
            );
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        }
      } else {
        _showError("Invalid Username or Password");
      }
    } catch (e) {
      _showError("Connection Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomPaint(
        painter: WavePainter(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Added App Name "VeriStay"
              const Text(
                "VeriStay",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: _handleLogin,
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            ),
                            child: const Text("Don't have an account? Sign up"),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import 'register_screen.dart';
// import 'home_screen.dart';
// import '../widgets/wave_painter.dart';
// // Sahi dashboards ko call karne ke liye imports
// import 'admin_dashboard.dart';
// import 'police_dashboard.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _authService = AuthService();
//   bool _isLoading = false;

//   void _handleLogin() async {
//     if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
//       _showError("Please enter credentials");
//       return;
//     }

//     setState(() => _isLoading = true);
//     try {
//       final response = await _authService.login(
//         _usernameController.text.trim(),
//         _passwordController.text.trim(),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         // Role extraction and cleaning
//         String userRole = (data['role'] ?? data['Role'] ?? 'hotel')
//             .toString()
//             .toLowerCase()
//             .trim();

//         print("DEBUG: Navigating to Dashboard for -> $userRole");

//         if (mounted) {
//           Widget nextScreen;

//           // Yahan hum aapki banayi hui real classes ko call kar rahe hain
//           if (userRole == 'admin') {
//             nextScreen = const AdminDashboard();
//           } else if (userRole == 'police') {
//             nextScreen = const PoliceDashboard();
//           } else {
//             nextScreen = HomeScreen(
//               fullName: data['fullName'] ?? "User",
//               email: data['email'] ?? "",
//             );
//           }

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => nextScreen),
//           );
//         }
//       } else {
//         _showError("Invalid Username or Password");
//       }
//     } catch (e) {
//       _showError("Connection Error: $e");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomPaint(
//         painter: WavePainter(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 40.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "LOGIN",
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF4A90E2),
//                   letterSpacing: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: "Username",
//                   prefixIcon: Icon(Icons.person_outline),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   prefixIcon: Icon(Icons.lock_outline),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Center(
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : Column(
//                         children: [
//                           SizedBox(
//                             width: 220,
//                             height: 50,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.orangeAccent,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               onPressed: _handleLogin,
//                               child: const Text(
//                                 "LOGIN",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const RegisterScreen(),
//                               ),
//                             ),
//                             child: const Text("Don't have an account? Sign up"),
//                           ),
//                         ],
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // CRITICAL: Yahan se 'class AdminDashboard' aur 'class PoliceDashboard' hatani hain
// // Kyunki wo files already imported hain.
