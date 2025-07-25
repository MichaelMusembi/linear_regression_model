import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Color getPredictionColor(double value) {
    if (value < 50) return Colors.green;
    if (value < 100) return Colors.orange;
    return Colors.red;
  }

  String getPredictionLevel(double value) {
    if (value < 50) return 'Low Risk';
    if (value < 100) return 'Moderate Risk';
    return 'High Risk';
  }

  Widget buildInputSummary(Map<String, dynamic> inputData) {
    final Map<String, String> displayNames = {
      'People using safely managed drinking water services, urban (% of urban population)':
          'Urban Safely Managed Water',
      'Rural population growth (annual %)': 'Rural Population Growth',
      'Urban population growth (annual %)': 'Urban Population Growth',
      'People using at least basic drinking water services (% of population)':
          'Basic Water Services',
      'People using at least basic drinking water services, rural (% of rural population)':
          'Basic Water - Rural',
      'People using at least basic drinking water services, urban (% of urban population)':
          'Basic Water - Urban',
      'People using at least basic sanitation services (% of population)':
          'Basic Sanitation',
      'People using at least basic sanitation services, rural (% of rural population)':
          'Basic Sanitation - Rural',
      'People using at least basic sanitation services, urban  (% of urban population)':
          'Basic Sanitation - Urban',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Input Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...inputData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        displayNames[entry.key] ?? entry.key,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${entry.value.toStringAsFixed(1)}%',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final double prediction = args['prediction'];
    final Map<String, dynamic> inputData = args['inputData'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Result'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Result Card
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      getPredictionColor(prediction).withValues(alpha: 0.1),
                      getPredictionColor(prediction).withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics,
                      size: 60,
                      color: getPredictionColor(prediction),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Predicted Malaria Incidence',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prediction.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: getPredictionColor(prediction),
                      ),
                    ),
                    Text(
                      'per 1,000 population at risk',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: getPredictionColor(prediction),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getPredictionLevel(prediction),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Risk Interpretation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Risk Interpretation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                            child: Text(
                                'Low Risk (< 50 per 1,000): Well-managed water and sanitation')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                            child: Text(
                                'Moderate Risk (50-100 per 1,000): Some improvements needed')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                            child: Text(
                                'High Risk (> 100 per 1,000): Urgent intervention required')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Input Summary
            buildInputSummary(inputData),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/input',
                        (route) => route.settings.name == '/',
                      );
                    },
                    child: const Text('New Prediction'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Home'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
