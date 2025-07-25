import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isCheckingConnection = false;
  bool? isConnected;

  @override
  void initState() {
    super.initState();
    _checkApiConnection();
  }

  Future<void> _checkApiConnection() async {
    setState(() => isCheckingConnection = true);
    final connected = await ApiService.testConnection();
    setState(() {
      isConnected = connected;
      isCheckingConnection = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade400,
              Colors.teal.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.health_and_safety,
                    size: 80,
                    color: Colors.teal.shade600,
                  ),
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'Malaria Predictor',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Predict malaria incidence rates based on water and sanitation data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 60),

                // Connection Status
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isCheckingConnection)
                          const CircularProgressIndicator()
                        else if (isConnected == true)
                          const Icon(Icons.check_circle, color: Colors.green)
                        else if (isConnected == false)
                          const Icon(Icons.error, color: Colors.red)
                        else
                          const Icon(Icons.help, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          isCheckingConnection
                              ? 'Checking API connection...'
                              : isConnected == true
                                  ? 'API Connected'
                                  : isConnected == false
                                      ? 'API Connection Failed'
                                      : 'Unknown Status',
                          style: TextStyle(
                            color: isConnected == true
                                ? Colors.green
                                : isConnected == false
                                    ? Colors.red
                                    : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Start Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/input');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Start Prediction',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Retry Connection Button
                if (isConnected == false)
                  TextButton(
                    onPressed: _checkApiConnection,
                    child: const Text(
                      'Retry Connection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
