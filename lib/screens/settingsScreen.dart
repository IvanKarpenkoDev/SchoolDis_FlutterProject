import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/about_app.dart';
import 'package:get/get.dart';

class SettingsPage1 extends StatefulWidget {
  SettingsPage1({Key? key}) : super(key: key);

  @override
  State<SettingsPage1> createState() => _SettingsPage1State();
}

class _SettingsPage1State extends State<SettingsPage1> {
  bool isTheme = false;


  @override
  void initState() {
    isTheme = Get.theme.brightness == Brightness.dark;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
      ),
      //backgroundColor: const Color(0xfff6f6f6),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "Основные",
                
                children: [
                   _CustomListTile(
                    title: "О приложении",
                    icon: Icons.info_outline,
                    funct: () {
                       Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutAppPage()));
                    },
                    
                  ),
                  _CustomListTile(
                      title: "Темная тема",
                      icon: Icons.dark_mode_outlined,
                      trailing: CupertinoSwitch(
                          value:  isTheme,
                          onChanged: (value) {
                            setState(() {
                              isTheme = !isTheme;
                              Get.changeThemeMode(
                                  isTheme ? ThemeMode.dark : ThemeMode.light);
                            });
                          })),
                  const _CustomListTile(
                      title: "Какая то настройка",
                      icon: CupertinoIcons.cloud_download),
                  const _CustomListTile(
                      title: "Какая то настройка",
                      icon: CupertinoIcons.lock_shield),
                ],
              ),
              _SingleSection(
                title: "Privacy and Security",
                children: [
                  _CustomListTile(
                    title: "Какая то настройка",
                    icon: CupertinoIcons.person_2,
                    funct: () {
                      print('aasdlaksd');
                    },
                  ),
                  _CustomListTile(
                      title: "Какая то настройка", icon: CupertinoIcons.lock),
                  _CustomListTile(
                      title: "Какая то настройка",
                      icon: CupertinoIcons.brightness),
                  _CustomListTile(
                      title: "Какая то настройка",
                      icon: CupertinoIcons.speaker_2),
                  _CustomListTile(
                      title: "Какая то настройка",
                      icon: CupertinoIcons.paintbrush)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function()? funct;
  const _CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      this.trailing,
      this.funct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: funct);
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style:
                Theme.of(context).textTheme.headline3?.copyWith(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
         //color: Colors.white,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
