import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/sg_button.dart';
import '../common/sg_button_icon_with_popup.dart';
import '../common/sg_popup_controller.dart';
import '../common/sg_popup_menu.dart';
import '../constants/sg_app_svgs.dart';

class PopupButtonExample extends StatefulWidget {
  const PopupButtonExample({super.key});

  @override
  State<PopupButtonExample> createState() => _PopupButtonExampleState();
}

class _PopupButtonExampleState extends State<PopupButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popup Button Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'These buttons are in the same group - click one to close the other',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Example 1: Simple button with popup having title and buttons
                SGButtonIconWithPopup(
                  icon: SGAppSvgs.iconTime,
                  popupId: 'example_time',
                  popupItems: [
                    SGPopupMenuItem(
                      title: 'Time Options',
                      content: const Text('Choose a time option:'),
                      buttons: [
                        SGButton(
                          text: 'Today',
                          onclick: () {
                            debugPrint('Today selected');
                          },
                        ),
                        SGButton(
                          text: 'Yesterday',
                          onclick: () {
                            debugPrint('Yesterday selected');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(width: 50),
                
                // Example 2: Button with popup having multiple items
                SGButtonIconWithPopup(
                  icon: SGAppSvgs.iconSetting,
                  popupId: 'example_settings',
                  popupItems: [
                    SGPopupMenuItem(
                      title: 'Settings',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSettingOption(context, 'Dark Mode', true),
                          _buildSettingOption(context, 'Notifications', false),
                          _buildSettingOption(context, 'Auto-save', true),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 50),
            const Text(
              'This button is not in any group',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Example 3: Button with popup having just items (no title or buttons)
            SGButtonIconWithPopup(
              icon: SGAppSvgs.iconSliders,
              popupItems: [
                SGPopupMenuItem(
                  content: _buildSimpleMenuItem(
                    context, 
                    'Option 1', 
                    SGAppSvgs.iconSearch,
                  ),
                ),
                SGPopupMenuItem(
                  content: _buildSimpleMenuItem(
                    context, 
                    'Option 2', 
                    SGAppSvgs.iconSliders,
                  ),
                ),
                SGPopupMenuItem(
                  content: _buildSimpleMenuItem(
                    context, 
                    'Option 3', 
                    SGAppSvgs.iconChat,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create setting option with toggle
  Widget _buildSettingOption(BuildContext context, String title, bool initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Switch(
            value: initialValue,
            onChanged: (value) {
              debugPrint('$title set to $value');
            },
          ),
        ],
      ),
    );
  }

  // Helper method to create simple menu item
  Widget _buildSimpleMenuItem(BuildContext context, String title, String icon) {
    return InkWell(
      onTap: () {
        debugPrint('$title selected');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
      ),
    );
  }
} 