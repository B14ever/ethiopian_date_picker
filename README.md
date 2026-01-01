Ethiopian Date Picker
A highly customizable and localized Ethiopian date picker for Flutter applications, designed for easy date selection and seamless integration with Gregorian date systems.

✨ Features
Bidirectional Calendar Conversion:

Input Flexibility: Accepts standard Gregorian DateTime objects for initialDate, firstDate, and lastDate. These are automatically converted and displayed in the Ethiopian calendar.

Seamless Output: Returns the user-selected Ethiopian date as a standard Gregorian DateTime object, ensuring effortless compatibility with your existing application logic.

Ethiopian Calendar Display: Provides a customizable dialog-based date picker presenting dates in the Ethiopian calendar system.

Intuitive Navigation:

Effortless month-by-month navigation using chevron buttons.

Quick year selection via a convenient dropdown grid.

Date Range Constraints: Define firstDate and lastDate (in Gregorian) to limit selectable dates; unavailable days are visually grayed out and navigation respects these boundaries.

Clear Visual Feedback:

The actively selected date is prominently highlighted with a circular green background.

firstDay and lastDay are styled differently for easy identification.

Out-of-range dates are grayed out and non-interactive.

Comprehensive Localization:

Supports multiple Ethiopian languages and English for month names, day abbreviations (e.g., S, M, T), dialog titles, and action button texts.

Currently includes: English (US), Amharic (AM), Oromiffa (OR), Tigrinya (TI), Sidama (SI - placeholders), Somali (SO - placeholders).

Defaults to English if no localization is specified.

🚀 Installation
Add this to your pubspec.yaml file:

dependencies:
  ethiopian_date_picker: ^0.1.0 # Significant update with robust conversion

Then, run flutter pub get to fetch the package.

📦 Usage
To use the date picker, simply call showEthiopianDatePicker from your BuildContext.

import 'package:flutter/material.dart';
import 'package:ethiopian_date_picker/ethiopian_date_picker.dart'; // Adjust import based on your package structure
import 'package:ethiopian_date_picker/src/localization_data.dart'; // For localization enum

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethiopian Date Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? _selectedDate; // This will hold the Gregorian DateTime

  Future<void> _pickDate() async {
    // Pass initialDate, firstDate, and lastDate as Gregorian DateTime
    final DateTime? picked = await showEthiopianDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023, 1, 1), // Gregorian start date for range
      lastDate: DateTime(2025, 12, 31), // Gregorian end date for range
      localization: EthiopianDatePickerLocalization.am, // Example: for Amharic
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // The returned value is already Gregorian
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected Gregorian Date: ${_selectedDate?.toIso8601String().split('T').first}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethiopian Date Picker Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _selectedDate == null
                  ? 'No date selected (Gregorian)'
                  : 'Selected Date (Gregorian): ${_selectedDate!.toIso8601String().split('T').first}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Open Ethiopian Date Picker'),
            ),
          ],
        ),
      ),
    );
  }
}

Localization Support
The localization parameter in showEthiopianDatePicker allows you to specify the language for the picker's UI elements.

Available localizations (from EthiopianDatePickerLocalization enum):

`EthiopianDatePickerLocalization.us` (English - Default)

`EthiopianDatePickerLocalization.am` (Amharic)

`EthiopianDatePickerLocalization.or` (Oromiffa)

`EthiopianDatePickerLocalization.ti` (Tigrinya)

`EthiopianDatePickerLocalization.si` (Sidama)

`EthiopianDatePickerLocalization.so` (Somali)

💡 How it Works (Key Insight)
The ethiopian_date_picker package bridges the gap between Gregorian and Ethiopian calendars using robust mathematical formulas that handle the 4-year cycle (365, 365, 366, 365 days) indefinitely. This ensures accuracy during leap years and New Year transitions without needing manual updates.

When you provide DateTime objects (Gregorian) for initial dates or range constraints, the picker intelligently converts them to Ethiopian for display. When a user makes a selection in the Ethiopian calendar, the chosen date is automatically converted back to a Gregorian DateTime object and returned to your application. This seamless bidirectional conversion allows you to work primarily with Gregorian dates in your app while offering a fully localized Ethiopian date selection experience to your users.

🛣️ What's Next? (Follow for more!)
This is just the beginning for ethiopian_date_picker! I'm planning to add more exciting features and enhancements to make it even more powerful and versatile.

Follow this package on pub.dev and/or star the repository on GitHub to stay updated on future releases, new features, and improvements! Your support helps grow this project.

🤝 Contributing
Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request on the GitHub issue tracker.

📄 License
This project is licensed under the MIT License.