import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _formKey = GlobalKey<FormState>();
  late double budget;
  late double monthlyIncome;
  late Map<String, double> expenseAllocations = {
    "Food": 0,
    "Transportation": 0,
    "Entertainment": 0,
    "Rent and Utilities": 0,
    "Insurance": 0,
    "Other": 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker - Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Budget'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget';
                  }
                  return null;
                },
                onSaved: (value) {
                  budget = double.parse(value!);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monthly Income'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter monthly income';
                  }
                  return null;
                },
                onSaved: (value) {
                  monthlyIncome = double.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              const Text('Expense Allocations:'),
              for (var entry in expenseAllocations.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(entry.key),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            expenseAllocations[entry.key] = double.parse(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (_validateExpenseAllocations(expenseAllocations.values.toList())) {
                      Navigator.pop(context, {
                        'budget': budget,
                        'monthlyIncome': monthlyIncome,
                        'expenseAllocations': expenseAllocations,
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Total expense allocations exceed budget!'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateExpenseAllocations(List<double> allocations) {
    final totalAllocations = allocations.reduce((value, element) => value + element);
    return totalAllocations <= budget;
  }
}
