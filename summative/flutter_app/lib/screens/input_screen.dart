import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final Map<String, TextEditingController> controllers = {
    'urban_managed_water': TextEditingController(),
    'rural_pop_growth': TextEditingController(),
    'urban_pop_growth': TextEditingController(),
    'basic_water': TextEditingController(),
    'basic_water_rural': TextEditingController(),
    'basic_water_urban': TextEditingController(),
    'basic_sanitation': TextEditingController(),
    'basic_sanitation_rural': TextEditingController(),
    'basic_sanitation_urban': TextEditingController(),
  };

  final Map<String, String> fieldLabels = {
    'urban_managed_water': 'Urban Safely Managed Water (%)',
    'rural_pop_growth': 'Rural Population Growth (%)',
    'urban_pop_growth': 'Urban Population Growth (%)',
    'basic_water': 'Basic Water Services (%)',
    'basic_water_rural': 'Basic Water Services - Rural (%)',
    'basic_water_urban': 'Basic Water Services - Urban (%)',
    'basic_sanitation': 'Basic Sanitation Services (%)',
    'basic_sanitation_rural': 'Basic Sanitation Services - Rural (%)',
    'basic_sanitation_urban': 'Basic Sanitation Services - Urban (%)',
  };

  final Map<String, String> fieldDescriptions = {
    'urban_managed_water':
        'Percentage of urban population using safely managed drinking water',
    'rural_pop_growth': 'Annual percentage growth rate of rural population',
    'urban_pop_growth': 'Annual percentage growth rate of urban population',
    'basic_water':
        'Percentage of total population using basic drinking water services',
    'basic_water_rural':
        'Percentage of rural population using basic drinking water services',
    'basic_water_urban':
        'Percentage of urban population using basic drinking water services',
    'basic_sanitation':
        'Percentage of total population using basic sanitation services',
    'basic_sanitation_rural':
        'Percentage of rural population using basic sanitation services',
    'basic_sanitation_urban':
        'Percentage of urban population using basic sanitation services',
  };

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validateInput(String? value, String fieldKey) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    // Validate ranges based on field type
    if (fieldKey.contains('growth')) {
      if (number < -10 || number > 10) {
        return 'Growth rate should be between -10% and 10%';
      }
    } else {
      if (number < 0 || number > 100) {
        return 'Percentage should be between 0 and 100';
      }
    }

    return null;
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors above'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final payload = {
        "People using safely managed drinking water services, urban (% of urban population)":
            double.parse(controllers['urban_managed_water']!.text),
        "Rural population growth (annual %)":
            double.parse(controllers['rural_pop_growth']!.text),
        "Urban population growth (annual %)":
            double.parse(controllers['urban_pop_growth']!.text),
        "People using at least basic drinking water services (% of population)":
            double.parse(controllers['basic_water']!.text),
        "People using at least basic drinking water services, rural (% of rural population)":
            double.parse(controllers['basic_water_rural']!.text),
        "People using at least basic drinking water services, urban (% of urban population)":
            double.parse(controllers['basic_water_urban']!.text),
        "People using at least basic sanitation services (% of population)":
            double.parse(controllers['basic_sanitation']!.text),
        "People using at least basic sanitation services, rural (% of rural population)":
            double.parse(controllers['basic_sanitation_rural']!.text),
        "People using at least basic sanitation services, urban  (% of urban population)":
            double.parse(controllers['basic_sanitation_urban']!.text),
      };

      final result = await ApiService.predictMalaria(payload);

      if (mounted && result != null) {
        Navigator.pushNamed(
          context,
          '/result',
          arguments: {
            'prediction': result,
            'inputData': payload,
          },
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Prediction failed. Please check your inputs and try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildInputCard(String key) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldLabels[key]!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              fieldDescriptions[key]!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controllers[key],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText:
                    key.contains('growth') ? 'e.g., 2.5 or -1.2' : 'e.g., 85.5',
                suffixText: '%',
              ),
              validator: (value) => _validateInput(value, key),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Data'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.teal.shade50,
              child: Column(
                children: [
                  Icon(
                    Icons.input,
                    size: 40,
                    color: Colors.teal.shade600,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter the required data for malaria prediction',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'All fields are required',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Input Fields
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: controllers.keys.map(_buildInputCard).toList(),
              ),
            ),

            // Predict Button
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _predict,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Text('Predicting...'),
                          ],
                        )
                      : const Text(
                          'Predict',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
