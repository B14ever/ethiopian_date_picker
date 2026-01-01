// lib/src/ethiopian_date_picker.dart

import 'package:flutter/material.dart';
import 'ethiopian_date.dart';
import 'calendar_converter.dart';
import 'calendar_grid.dart';
import 'header.dart';
import 'localization_data.dart'; // Import the new localization data

class EthiopianDatePicker extends StatefulWidget {
  final dynamic initialDate;
  final void Function(dynamic) onDateSelected;
  final EthiopianDate? firstDay;
  final EthiopianDate? lastDay;
  final ValueChanged<EthiopianDate?>? onSelectedDateChanged;
  final EthiopianDatePickerLocalization localization; // New parameter

  const EthiopianDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.firstDay,
    this.lastDay,
    this.onSelectedDateChanged,
    this.localization = EthiopianDatePickerLocalization.us, // Default to us
  });

  @override
  State<EthiopianDatePicker> createState() => _EthiopianDatePickerState();
}

Future<DateTime?> showEthiopianDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  EthiopianDatePickerLocalization localization =
      EthiopianDatePickerLocalization.us, // New parameter
}) {
  final pickerKey = GlobalKey<_EthiopianDatePickerState>();

  EthiopianDate? ethFirstDay;
  if (firstDate != null) {
    final eth = CalendarConverter.toEthiopian(firstDate);
    ethFirstDay = EthiopianDate(eth[0], eth[1], eth[2]);
  }

  EthiopianDate? ethLastDay;
  if (lastDate != null) {
    final eth = CalendarConverter.toEthiopian(lastDate);
    ethLastDay = EthiopianDate(eth[0], eth[1], eth[2]);
  }

  final ValueNotifier<EthiopianDate?> selectedDateNotifier =
      ValueNotifier(null);
  final appLocalizations =
      CalendarLocalizations(localization); // Create instance here

  return showDialog<DateTime>(
    useSafeArea: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.only(left: 5, right: 5),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appLocalizations.getText('selectDate'), // Localized "Select date"
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder<EthiopianDate?>(
              valueListenable: selectedDateNotifier,
              builder: (context, selectedDate, child) {
                String dateToDisplay;
                if (selectedDate != null) {
                  dateToDisplay =
                      "${appLocalizations.months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}"; // Use localized month name
                } else {
                  final initialEthDate =
                      _resolveInitialEthiopianDate(initialDate);
                  dateToDisplay = initialEthDate != null
                      ? "${appLocalizations.months[initialEthDate.month - 1]} ${initialEthDate.day}, ${initialEthDate.year}" // Use localized month name
                      : appLocalizations.getText(
                          'noDateSelected'); // Localized "No date selected"
                }

                return Text(
                  dateToDisplay,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                );
              },
            ),
            const Divider(height: 18, thickness: 1, color: Colors.black)
          ],
        ),
        content: EthiopianDatePicker(
          key: pickerKey,
          initialDate: initialDate,
          onDateSelected: (_) {},
          firstDay: ethFirstDay,
          lastDay: ethLastDay,
          onSelectedDateChanged: (newSelectedDate) {
            selectedDateNotifier.value = newSelectedDate;
          },
          localization: localization, // Pass localization to the widget
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(dialogContext).textTheme.labelLarge),
            child: Text(
              appLocalizations.getText('cancel'), // Localized "Cancel"
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(dialogContext).textTheme.labelLarge),
            child: Text(
              appLocalizations.getText('ok'), // Localized "Ok"
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              final selected = selectedDateNotifier.value;
              if (selected != null) {
                final greg = CalendarConverter.toGregorian(
                  selected.year,
                  selected.month,
                  selected.day,
                );
                Navigator.of(dialogContext).pop(greg);
              } else {
                Navigator.of(dialogContext).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

// Helper function to resolve initial EthiopianDate for display in the title
EthiopianDate? _resolveInitialEthiopianDate(DateTime? initialGregorianDate) {
  if (initialGregorianDate != null) {
    final eth = CalendarConverter.toEthiopian(initialGregorianDate);
    return EthiopianDate(eth[0], eth[1], eth[2]);
  }
  return null;
}

class _EthiopianDatePickerState extends State<EthiopianDatePicker> {
  late EthiopianDate _displayedDate;
  EthiopianDate? _selectedDate;
  final GlobalKey calendarGridKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _displayedDate = _resolveInitialDate();
    if (widget.initialDate != null) {
      final date = widget.initialDate as DateTime;
      final eth = CalendarConverter.toEthiopian(date);
      _selectedDate = EthiopianDate(eth[0], eth[1], eth[2]);
    }
  }

  EthiopianDate _resolveInitialDate() {
    if (widget.initialDate != null) {
      final date = widget.initialDate as DateTime;
      final eth = CalendarConverter.toEthiopian(date);
      return EthiopianDate(eth[0], eth[1], eth[2]);
    }
    final now = DateTime.now();
    final eth = CalendarConverter.toEthiopian(now);
    return EthiopianDate(eth[0], eth[1], eth[2]);
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedDate = _displayedDate.previousMonth;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedDate = _displayedDate.nextMonth;
    });
  }

  void _handleDateSelection(EthiopianDate selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
    widget.onSelectedDateChanged?.call(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 370,
      child: Column(
        children: [
          PickerHeader(
            calendarGridKey: calendarGridKey,
            year: _displayedDate.year,
            month: _displayedDate.month,
            onPrevious: _goToPreviousMonth,
            onNext: _goToNextMonth,
            onYearChanged: (newYear) {
              setState(() {
                _displayedDate =
                    EthiopianDate(newYear, _displayedDate.month, 1);
              });
            },
            firstDay: widget.firstDay,
            lastDay: widget.lastDay,
            localization: widget.localization, // Pass localization
          ),
          CalendarGrid(
            key: calendarGridKey,
            year: _displayedDate.year,
            month: _displayedDate.month,
            onDateSelected: _handleDateSelection,
            selectedDate: _selectedDate,
            firstDay: widget.firstDay,
            lastDay: widget.lastDay,
            localization: widget.localization, // Pass localization
          )
        ],
      ),
    );
  }
}
