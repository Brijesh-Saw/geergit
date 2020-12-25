import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _checkBox1 = false;
  bool _checkBox2 = false;
  void _checked() {
    setState(() {
      _checkBox1 = !_checkBox1;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.blue));
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.red,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Geergit",
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: "Quando",
          ),
        ),
      ),
      body: Container(
        color: Colors.blue,
        child: _ListAppsPagesContent(
            checkBox1: _checkBox1, checkBox2: _checkBox2, key: GlobalKey()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.upload_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        color: Colors.blue[400],
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.menu, size: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListAppsPagesContent extends StatelessWidget {
  final bool checkBox1;
  final bool checkBox2;

  const _ListAppsPagesContent(
      {Key key, this.checkBox1: false, this.checkBox2: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool checkBox = false;
    bool checkBoxa = false;
    return FutureBuilder<List<Application>>(
        future: DeviceApps.getInstalledApplications(
            includeAppIcons: true,
            includeSystemApps: true,
            onlyAppsWithLaunchIntent: true),
        builder: (BuildContext context, AsyncSnapshot<List<Application>> data) {
          if (data.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = data.data;
            print(apps);
            return Scrollbar(
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int position) {
                    Application app = apps[position];
                    return Column(
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.all(5.0)),
                        Container(
                          width: MediaQuery.of(context).size.width - 20.0,
                          height: 150,
                          child: Material(
                            color: Colors.white,
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(7.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: app is ApplicationWithIcon
                                      ? CircleAvatar(
                                          backgroundImage:
                                              MemoryImage(app.icon),
                                          backgroundColor: Colors.white,
                                        )
                                      : null,
                                  onTap: () =>
                                      DeviceApps.openApp(app.packageName),
                                  title: Text('${app.appName}'),
                                  subtitle: Text('${app.packageName}'),
                                  trailing: ToggleButtons(
                                    children: [
                                      Icon(Icons.rounded_corner_rounded),
                                    ],
                                    isSelected: [true],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 50.0,
                                  child: Divider(
                                    color: Colors.black,
                                    height: 2,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Checkbox(
                                        value: checkBox1,
                                        onChanged: (bool value) {
                                          print(value);
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: Checkbox(
                                          value: checkBox2,
                                          onChanged: (bool value) {
                                            print(value);
                                          }),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 10.0,
                        )
                      ],
                    );
                  },
                  itemCount: apps.length),
            );
          }
        });
  }
}
