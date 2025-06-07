import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const UnitConverterScreen(),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputValueController = TextEditingController();

  String? _fromUnit;
  String? _toUnit;
  String _conversionResult = '0.0';

  final List<String> _lengthUnits = [
    'Meters', 'Kilometers', 'Centimeters', 'Millimeters', 'Miles', 'Feet', 'Inches'
  ];
  final List<String> _weightUnits = [
    'Grams', 'Kilograms', 'Pounds', 'Ounces'
  ];
  final List<String> _temperatureUnits = [
    'Celsius', 'Fahrenheit', 'Kelvin'
  ];

  // Combine all units for the dropdowns
  late final List<String> _allUnits;

  @override
  void initState() {
    super.initState();
    _allUnits = [..._lengthUnits, ..._weightUnits, ..._temperatureUnits];
    _fromUnit = _allUnits[0]; // Default to Meters
    _toUnit = _allUnits[1];   // Default to Kilometers
  }

  @override
  void dispose() {
    _inputValueController.dispose();
    super.dispose();
  }

  // Determines the category of a unit (Length, Weight, Temperature)
  String _getUnitCategory(String unit) {
    if (_lengthUnits.contains(unit)) {
      return 'length';
    } else if (_weightUnits.contains(unit)) {
      return 'weight';
    } else if (_temperatureUnits.contains(unit)) {
      return 'temperature';
    }
    return 'unknown'; // Should not happen if units are well-defined
  }

  void _convertUnits() {
    final String inputString = _inputValueController.text;
    final double? inputValue = double.tryParse(inputString);

    if (inputValue == null) {
      setState(() {
        _conversionResult = 'Invalid input!';
      });
      return;
    }

    if (_fromUnit == null || _toUnit == null) {
      setState(() {
        _conversionResult = 'Please select both units!';
      });
      return;
    }

    final String fromCategory = _getUnitCategory(_fromUnit!);
    final String toCategory = _getUnitCategory(_toUnit!);

    if (fromCategory != toCategory) {
      setState(() {
        _conversionResult = 'Cannot convert between different categories!';
      });
      return;
    }

    double result = 0.0;

    switch (fromCategory) {
      case 'length':
        result = _convertLength(inputValue, _fromUnit!, _toUnit!);
        break;
      case 'weight':
        result = _convertWeight(inputValue, _fromUnit!, _toUnit!);
        break;
      case 'temperature':
        result = _convertTemperature(inputValue, _fromUnit!, _toUnit!);
        break;
      default:
        _conversionResult = 'Conversion not supported for this unit type.';
        break;
    }

    setState(() {
      _conversionResult = result.toStringAsFixed(4); // Format to 4 decimal places
    });
  }

  // --- Length Conversion Logic (Base: Meters) ---
  double _convertLength(double value, String fromUnit, String toUnit) {
    double valueInMeters;

    // Convert to Meters (Base Unit)
    switch (fromUnit) {
      case 'Meters':
        valueInMeters = value;
        break;
      case 'Kilometers':
        valueInMeters = value * 1000;
        break;
      case 'Centimeters':
        valueInMeters = value / 100;
        break;
      case 'Millimeters':
        valueInMeters = value / 1000;
        break;
      case 'Miles':
        valueInMeters = value * 1609.34;
        break;
      case 'Feet':
        valueInMeters = value * 0.3048;
        break;
      case 'Inches':
        valueInMeters = value * 0.0254;
        break;
      default:
        return 0.0; // Should not happen
    }

    // Convert from Meters to Target Unit
    switch (toUnit) {
      case 'Meters':
        return valueInMeters;
      case 'Kilometers':
        return valueInMeters / 1000;
      case 'Centimeters':
        return valueInMeters * 100;
      case 'Millimeters':
        return valueInMeters * 1000;
      case 'Miles':
        return valueInMeters / 1609.34;
      case 'Feet':
        return valueInMeters / 0.3048;
      case 'Inches':
        return valueInMeters / 0.0254;
      default:
        return 0.0; // Should not happen
    }
  }

  // --- Weight Conversion Logic (Base: Grams) ---
  double _convertWeight(double value, String fromUnit, String toUnit) {
    double valueInGrams;

    // Convert to Grams (Base Unit)
    switch (fromUnit) {
      case 'Grams':
        valueInGrams = value;
        break;
      case 'Kilograms':
        valueInGrams = value * 1000;
        break;
      case 'Pounds':
        valueInGrams = value * 453.592;
        break;
      case 'Ounces':
        valueInGrams = value * 28.3495;
        break;
      default:
        return 0.0;
    }

    // Convert from Grams to Target Unit
    switch (toUnit) {
      case 'Grams':
        return valueInGrams;
      case 'Kilograms':
        return valueInGrams / 1000;
      case 'Pounds':
        return valueInGrams / 453.592;
      case 'Ounces':
        return valueInGrams / 28.3495;
      default:
        return 0.0;
    }
  }

  // --- Temperature Conversion Logic (Base: Celsius) ---
  double _convertTemperature(double value, String fromUnit, String toUnit) {
    double valueInCelsius;

    // Convert to Celsius (Base Unit)
    switch (fromUnit) {
      case 'Celsius':
        valueInCelsius = value;
        break;
      case 'Fahrenheit':
        valueInCelsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        valueInCelsius = value - 273.15;
        break;
      default:
        return 0.0;
    }

    // Convert from Celsius to Target Unit
    switch (toUnit) {
      case 'Celsius':
        return valueInCelsius;
      case 'Fahrenheit':
        return (valueInCelsius * 9 / 5) + 32;
      case 'Kelvin':
        return valueInCelsius + 273.15;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = const Color(0xFF1A73E8); // Uber-like blue accent
    final Color bg = const Color(0xFFF7F9FB); // Soft background
    final Color card = Colors.white;
    final Color border = const Color(0xFFE0E3E7);
    final Color resultGreen = const Color(0xFFDFF5E3);
    final Color textMain = const Color(0xFF222B45);
    final Color textSubtle = const Color(0xFF7B8794);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: bg,
            elevation: 0,
            pinned: true,
            centerTitle: true,
            iconTheme: IconThemeData(color: accent),
            title: Text(
              'Unit Converter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.1,
                color: accent,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: border, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.07),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _inputValueController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textMain),
                          decoration: InputDecoration(
                            labelText: 'Enter Value',
                            labelStyle: TextStyle(fontSize: 16, color: textSubtle),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            filled: true,
                            fillColor: bg,
                            prefixIcon: Icon(Icons.tune, color: accent, size: 26),
                            contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildUnitDropdown(
                          label: 'From Unit',
                          value: _fromUnit,
                          onChanged: (String? newValue) {
                            setState(() {
                              _fromUnit = newValue;
                            });
                          },
                          accent: accent,
                          bg: bg,
                          textMain: textMain,
                          textSubtle: textSubtle,
                        ),
                        const SizedBox(height: 16),
                        _buildUnitDropdown(
                          label: 'To Unit',
                          value: _toUnit,
                          onChanged: (String? newValue) {
                            setState(() {
                              _toUnit = newValue;
                            });
                          },
                          accent: accent,
                          bg: bg,
                          textMain: textMain,
                          textSubtle: textSubtle,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _convertUnits,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                            child: const Text('Convert'),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                            decoration: BoxDecoration(
                              color: resultGreen,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: border),
                            ),
                            child: Text(
                              'Result: $_conversionResult',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: textMain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitDropdown({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required Color accent,
    required Color bg,
    required Color textMain,
    required Color textSubtle,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 15, color: textSubtle),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: bg,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      value: value,
      icon: Icon(Icons.arrow_drop_down, size: 28, color: accent),
      style: TextStyle(fontSize: 18, color: textMain, fontWeight: FontWeight.w600),
      dropdownColor: Colors.white,
      items: _allUnits.map((String unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
            child: Text(unit, style: TextStyle(fontSize: 16, color: textMain)),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}