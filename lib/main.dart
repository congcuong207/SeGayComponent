import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/table_view_exemple.dart';
import 'package:se_gay_components/web_base/sg_sidebar/sg_sidebar.dart';
import 'package:se_gay_components/web_base/sg_web_base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(
          title: 's',
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectedIndex = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SGWebBase(
          name: "SGDash",
          menuItems: const [
            MenuItem(icon: Icons.abc, label: "Home", idMenu: "Home"),
            MenuItem(icon: Icons.cabin, label: "Category", children: [
              MenuItem(icon: Icons.abc, label: "Home", idMenu: "H"),
              MenuItem(icon: Icons.abc, label: "Home", idMenu: "M")
            ]),
          ],
          selectedIndex: selectedIndex,
          onItemSelected: (index, [subIndex]) {
            selectedIndex = index;
            setState(() {});
          },
          body: const TableViewExemple()),
    );
  }
}

class User {
  final int id;
  final String name;
  User({required this.id, required this.name});
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int? selectedValue;
  User? selectedUser;
  List<User> users = [
    User(id: 1, name: 'Alice'),
    User(id: 2, name: 'Bob'),
  ];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  List<DropdownMenuItem<User>> get userDropdownItems => users.map((user) {
        return DropdownMenuItem<User>(
          value: user,
          child: Text(user.name),
        );
      }).toList();

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
    const DropdownMenuItem(value: 55, child: Text('55')),
  ];

  String value = '';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // SGDropdownButton<int>(
        //   value: rowsPerPage,
        //   items: rowsPerPageOptions
        //       .map((e) => DropdownMenuItem<int>(
        //             value: e,
        //             child: Text(e.toString()),
        //           ))
        //       .toList(),
        //   onChanged: (value) {
        //     if (value != null) {
        //       setState(() {
        //         rowsPerPage = value;
        //         currentPage = 1;
        //       });
        //     }
        //   },
        // ),
        SGDropdownInputButton<User>(
          width: 250,
          value: selectedUser,
          items: userDropdownItems,
          textAlign: TextAlign.left,
          textAlignItem: TextAlign.left,
          defaultValue: users[1],
          colorSelectedText: SGAppColors.error500,
          onChanged: (user) {
            setState(() {
              selectedUser = user;
            });
            log('message onChanged: ${selectedUser!.id}');
          },
          controller: _controller2,
        ),
        SGDropdownInputButton<int>(
          controller: _controller,
          // inputType: TextInputType.number,
          // defaultValue: 10,
          colorBorderFocus: SGAppColors.error400,
          textAlign: TextAlign.center,
          fontSize: 12,
          contentPadding: const EdgeInsets.all(1),
          sizeBorderCircular: 2,
          enableSearch: false,
          isShowSuffixIcon: false,
          colorSelectedText: SGAppColors.error500,
          value: selectedValue,
          items: items,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            log('_controller: ${_controller.text}');
          },
          hintText: 'Chọn số...',
          width: 25,
          height: 25,
        ),
        SGInputText(
          controller: _controller,
          hintText: 'Chọn số...',
          height: 45,
          label: 'Tên',
          obscureText: true,
          maxLines: 3,
          isRequired: true,
          expandable: true, // update size textfield theo lines
          prefixIcon: const Icon(Icons.abc),
          // suffixIcon: const Icon(Icons.abc),
          // suffix: const Icon(Icons.abc),
        ),

      ],
    );
  }
}
