import 'package:flutter/material.dart';
import 'package:ethiopian_date_picker/ethiopian_date_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethiopian Date Picker Demo',
      home: const PickerDemoPage(),
    );
  }
}

// Updated demo page
class PickerDemoPage extends StatefulWidget {
  const PickerDemoPage({super.key});

  @override
  State<PickerDemoPage> createState() => _PickerDemoPageState();
}

class _PickerDemoPageState extends State<PickerDemoPage> {
  DateTime? _selectedDate;

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showEthiopianDatePicker(
      context: context,
      initialDate: _selectedDate,
      localization: EthiopianDatePickerLocalization.am,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final label =
        _selectedDate != null ? 'Selected: $_selectedDate' : 'No date selected';

    return Scaffold(
      appBar: AppBar(title: const Text('Ethiopian Calendar Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showDatePicker,
              child: const Text('Pick Ethiopian Date'),
            ),
          ],
        ),
      ),
    );
  }
}
