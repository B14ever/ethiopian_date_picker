# CHANGELOG

## 0.1.0 - 2026-01-01

### ✨ Major Logic & Reliability Improvements
- **Robust Mathematical Conversion**: Implemented a continuous mathematical conversion for the Ethiopian calendar (handling the 4-year cycle). This fixes the fragility of manual year-check thresholds and ensures accuracy for all future dates.
- **Fixed "One-Year Jump"**: Corrected the conversion bug where dates were jumping ahead by +1 year after the Gregorian New Year but before the Ethiopian New Year.
- **Immediate UI Updates**: Optimized selection logic for immediate feedback upon tapping a date.
- **Improved Visual Feedback**: Switched selection interaction to `InkWell` for native Flutter ripple effects and increased responsiveness.

### 🌍 Localization
- Full support for month names, day names, and UI labels in:
  - English (US)
  - Amharic (AM)
  - Oromiffa (OR)
  - Tigrinya (TI)
  - Sidama (SI)
  - Somali (SO)

---

## 0.0.1 - 2025-12-30
Initial Release of Ethiopian Date Picker.

- Gregorian <-> Ethiopian conversion.
- Dialog-based UI.
- Year selection grid.
- Min/Max date constraints.