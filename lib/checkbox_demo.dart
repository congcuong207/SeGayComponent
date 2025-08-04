import 'package:flutter/material.dart';
import 'common/switch/sg_checkbox.dart';

class CheckboxDemo extends StatefulWidget {
  const CheckboxDemo({Key? key}) : super(key: key);

  @override
  State<CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  bool _checkbox1 = true;
  bool _checkbox2 = false;
  bool _checkbox3 = true;
  bool _checkbox4 = false;
  bool _checkbox5 = true;
  bool _checkbox6 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SgCheckbox Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Checkbox Examples',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Basic checkbox
              _buildExampleSection(
                'Basic Checkbox',
                SgCheckbox(
                  value: _checkbox1,
                  onChanged: (value) => setState(() => _checkbox1 = value),
                  text: 'Chọn tất cả',
                ),
              ),
              
              // Checkbox with custom colors
              _buildExampleSection(
                'Custom Colors',
                SgCheckbox(
                  value: _checkbox2,
                  onChanged: (value) => setState(() => _checkbox2 = value),
                  text: 'Custom Colors',
                  checkedColor: Colors.purple,
                  checkmarkColor: Colors.white,
                ),
              ),
              
              // Checkbox with green theme
              _buildExampleSection(
                'Green Theme',
                SgCheckbox(
                  value: _checkbox3,
                  onChanged: (value) => setState(() => _checkbox3 = value),
                  text: 'Green Theme',
                  checkedColor: Colors.green,
                  checkmarkColor: Colors.white,
                ),
              ),
              
              // Checkbox with custom text style
              _buildExampleSection(
                'Custom Text Style',
                SgCheckbox(
                  value: _checkbox4,
                  onChanged: (value) => setState(() => _checkbox4 = value),
                  text: 'Custom Style',
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  checkedColor: Colors.orange,
                ),
              ),
              
              // Checkbox without text
              _buildExampleSection(
                'Without Text',
                SgCheckbox(
                  value: _checkbox5,
                  onChanged: (value) => setState(() => _checkbox5 = value),
                  checkedColor: Colors.red,
                  checkmarkColor: Colors.white,
                ),
              ),
              
              // Checkbox with custom size
              _buildExampleSection(
                'Custom Size',
                SgCheckbox(
                  value: _checkbox6,
                  onChanged: (value) => setState(() => _checkbox6 = value),
                  text: 'Large Checkbox',
                  size: 30.0,
                  checkedColor: Colors.indigo,
                ),
              ),
              
              // Multiple checkboxes
              _buildExampleSection(
                'Multiple Checkboxes',
                Column(
                  children: [
                    SgCheckbox(
                      value: _checkbox1,
                      onChanged: (value) => setState(() => _checkbox1 = value),
                      text: 'Option 1',
                    ),
                    const SizedBox(height: 8),
                    SgCheckbox(
                      value: _checkbox2,
                      onChanged: (value) => setState(() => _checkbox2 = value),
                      text: 'Option 2',
                    ),
                    const SizedBox(height: 8),
                    SgCheckbox(
                      value: _checkbox3,
                      onChanged: (value) => setState(() => _checkbox3 = value),
                      text: 'Option 3',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleSection(String title, Widget checkboxWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          checkboxWidget,
        ],
      ),
    );
  }
} 