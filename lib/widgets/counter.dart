import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onChanged;

  const Counter({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _increment() {
    if (_currentValue < widget.maxValue) {
      setState(() {
        _currentValue++;
        widget.onChanged(_currentValue);
      });
    }
  }

  void _decrement() {
    if (_currentValue > widget.minValue) {
      setState(() {
        _currentValue--;
        widget.onChanged(_currentValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _decrement,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor, // Fondo color primario
            foregroundColor: Colors.white, // Texto o icono blanco
          ),
          child: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '$_currentValue',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        ElevatedButton(
          onPressed: _increment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor, // Fondo color primario
            foregroundColor: Colors.white, // Texto o icono blanco
          ),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
