import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

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

  double? prediction;
  bool isLoading = false;

  Future<void> _predict() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

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
      setState(() {
        prediction = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Malaria Predictor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ...controllers.entries.map((entry) => TextFormField(
                    controller: entry.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: entry.key.replaceAll('_', ' ').toUpperCase(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a value';
                      }
                      return null;
                    },
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _predict,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Predict'),
              ),
              const SizedBox(height: 20),
              if (prediction != null)
                Text(
                  "Predicted malaria incidence: ${prediction!.toStringAsFixed(2)} per 1,000 population at risk",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
