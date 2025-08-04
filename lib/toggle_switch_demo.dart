import 'package:flutter/material.dart';
import 'common/switch/sg_toggle_switch.dart';

class ToggleSwitchDemo extends StatefulWidget {
  const ToggleSwitchDemo({Key? key}) : super(key: key);

  @override
  State<ToggleSwitchDemo> createState() => _ToggleSwitchDemoState();
}

class _ToggleSwitchDemoState extends State<ToggleSwitchDemo> {
  bool _switch1 = false;
  bool _switch2 = true;
  bool _switch3 = false;
  bool _switch4 = true;
  bool _switch5 = false;
  bool _switch6 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SgToggleSwitch Examples'),
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
                'Toggle Switch Examples',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Basic toggle switch
              _buildExampleSection(
                'Basic Toggle Switch',
                SgToggleSwitch(
                  value: _switch1,
                  onChanged: (value) => setState(() {
                    print("value: $value");
                    _switch1 = value;
                    print("switch1: $_switch1");
                  } ),
                  text: 'Basic Switch',
                ),
              ),
              
              // Toggle switch with custom colors
              _buildExampleSection(
                'Custom Colors',
                SgToggleSwitch(
                  value: _switch2,
                  onChanged: (value) => setState(() => _switch2 = value),
                  text: 'Custom Colors',
                  switchColor: Colors.purple,
                  knobColor: Colors.white,
                ),
              ),
              
              // Toggle switch with icons
              _buildExampleSection(
                'With Icons',
                SgToggleSwitch(
                  value: _switch3,
                  onChanged: (value) => setState(() => _switch3 = value),
                  text: 'With Icons',
                  onIcon: 'ON',
                  offIcon: 'OFF',
                  switchColor: Colors.orange,
                ),
              ),
              
              // Toggle switch with custom text style
              _buildExampleSection(
                'Custom Text Style',
                SgToggleSwitch(
                  value: _switch4,
                  onChanged: (value) => setState(() => _switch4 = value),
                  text: 'Custom Style',
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  switchColor: Colors.teal,
                ),
              ),
              
              // Toggle switch without text
              _buildExampleSection(
                'Without Text',
                SgToggleSwitch(
                  value: _switch5,
                  onChanged: (value) => setState(() => _switch5 = value),
                  switchColor: Colors.red,
                  onIcon: '✓',
                  offIcon: '✗',
                ),
              ),
              
              // Toggle switch with custom size
              _buildExampleSection(
                'Custom Size',
                SgToggleSwitch(
                  value: _switch6,
                  onChanged: (value) => setState(() => _switch6 = value),
                  text: 'Large Switch',
                  width: 80.0,
                  height: 40.0,
                  switchColor: Colors.indigo,
                ),
              ),
              
              // Toggle switch with neumorphic design (like the image)
              _buildExampleSection(
                'Neumorphic Design',
                SgToggleSwitch(
                  value: _switch1,
                  onChanged: (value) => setState(() => _switch1 = value),
                  text: 'Neumorphic Style',
                  switchColor: const Color(0xFF4CAF50),
                  trackColor: Colors.grey[300],
                  knobColor: Colors.white,
                  onIcon: '1',
                  offIcon: '0',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleSection(String title, Widget switchWidget) {
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
          switchWidget,
        ],
      ),
    );
  }
} 