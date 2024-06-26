import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchpaint/blank.dart';
import 'package:touchpaint/fill.dart';
import 'package:touchpaint/follow.dart';
import 'package:touchpaint/paint.dart';

const appDescription = 'A simple app for touch latency testing.';

void main() => runApp(PaintApp());

class PaintApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touchpaint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        appBarTheme: AppBarTheme(
          color: Color(0xff2b2b2b),
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(
            color: ColorScheme.dark().onSurface,
          ),
          backgroundColor: ColorScheme.dark().surface,
        )
      ),
      home: MainPage(),
    );
  }
}

enum Mode {
  PAINT,
  FILL,
  FOLLOW,
  BLANK
}

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Mode _mode = Mode.PAINT;
  bool _showSampleRate = false;
  double _paintBrushSize = 2;
  int _paintClearDelay = 0;
  bool _showEventPoints = false;
  late SharedPreferences _prefs;

  loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      _mode = Mode.values[_prefs.getInt('mode') ?? 0];
      _showSampleRate = _prefs.getBool('show_sample_rate') ?? false;
      _showEventPoints = _prefs.getBool('show_event_points') ?? false;
      _paintBrushSize = _prefs.getDouble('paint_brush_size') ?? 2;
      _paintClearDelay = _prefs.getInt('paint_clear_delay') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> _changeMode() async {
    Mode newMode = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            title: const Text('Select mode'),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('Paint'),
                onPressed: () { Navigator.pop(context, Mode.PAINT); },
              ),
              SimpleDialogOption(
                child: const Text('Fill'),
                onPressed: () { Navigator.pop(context, Mode.FILL); },
              ),
              SimpleDialogOption(
                child: const Text('Follow'),
                onPressed: () { Navigator.pop(context, Mode.FOLLOW); },
              ),
              SimpleDialogOption(
                child: const Text('Blank redraw'),
                onPressed: () { Navigator.pop(context, Mode.BLANK); },
              ),
            ],
        ),
    );

    if (newMode != null) {
      setState(() {
        _mode = newMode;
        _prefs?.setInt('mode', newMode.index);
      });
    }
  }

  Future<void> _changeBrushSize() async {
    double? newSize = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            title: const Text('Select brush size'),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('1 physical pixel'),
                onPressed: () { Navigator.pop(context, 1 / MediaQuery.of(context).devicePixelRatio); },
              ),
              SimpleDialogOption(
                child: const Text('1 px'),
                onPressed: () { Navigator.pop(context, 1.0); },
              ),
              SimpleDialogOption(
                child: const Text('2 px'),
                onPressed: () { Navigator.pop(context, 2.0); },
              ),
              SimpleDialogOption(
                child: const Text('3 px'),
                onPressed: () { Navigator.pop(context, 3.0); },
              ),
              SimpleDialogOption(
                child: const Text('5 px'),
                onPressed: () { Navigator.pop(context, 5.0); },
              ),
              SimpleDialogOption(
                child: const Text('10 px'),
                onPressed: () { Navigator.pop(context, 10.0); },
              ),
              SimpleDialogOption(
                child: const Text('15 px'),
                onPressed: () { Navigator.pop(context, 15.0); },
              ),
              SimpleDialogOption(
                child: const Text('50 px'),
                onPressed: () { Navigator.pop(context, 50.0); },
              ),
              SimpleDialogOption(
                child: const Text('150 px'),
                onPressed: () { Navigator.pop(context, 150.0); },
              ),
            ],
        ),
    );

    if (newSize != null) {
      setState(() {
        _paintBrushSize = newSize;
        _prefs?.setDouble('paint_brush_size', newSize);
      });
    }
  }

  Future<void> _changeClearDelay() async {
    int newDelay = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select paint clear delay'),
        children: <Widget>[
          SimpleDialogOption(
            child: const Text('On next stroke'),
            onPressed: () { Navigator.pop(context, 0); },
          ),
          SimpleDialogOption(
            child: const Text('100 ms'),
            onPressed: () { Navigator.pop(context, 100); },
          ),
          SimpleDialogOption(
            child: const Text('250 ms'),
            onPressed: () { Navigator.pop(context, 250); },
          ),
          SimpleDialogOption(
            child: const Text('500 ms'),
            onPressed: () { Navigator.pop(context, 500); },
          ),
          SimpleDialogOption(
            child: const Text('1 second'),
            onPressed: () { Navigator.pop(context, 1000); },
          ),
          SimpleDialogOption(
            child: const Text('2 seconds'),
            onPressed: () { Navigator.pop(context, 2000); },
          ),
          SimpleDialogOption(
            child: const Text('5 seconds'),
            onPressed: () { Navigator.pop(context, 5000); },
          ),
          SimpleDialogOption(
            child: const Text('Never'),
            onPressed: () { Navigator.pop(context, -1); },
          ),
        ],
      ),
    );

    if (newDelay != null) {
      setState(() {
        _paintClearDelay = newDelay;
        _prefs?.setInt('paint_clear_delay', newDelay);
      });
    }
  }

  void selectMenuItem(String item) async {
    switch (item) {
      case 'Show sample rate':
        setState(() {
          _showSampleRate = true;
          _prefs?.setBool('show_sample_rate', true);
        });
        break;
      case 'Hide sample rate':
        setState(() {
          _showSampleRate = false;
          _prefs?.setBool('show_sample_rate', false);
        });
        break;
      case 'Show event points':
        setState(() {
          _showEventPoints = true;
          _prefs?.setBool('show_event_points', true);
        });
        break;
      case 'Hide event points':
        setState(() {
          _showEventPoints = false;
          _prefs?.setBool('show_event_points', false);
        });
        break;
      case 'About':
        final packageInfo = await PackageInfo.fromPlatform();

        showAboutDialog(
          context: context,
          applicationIcon: Image.asset(
            'assets/icons/circle.png',
            width: 64,
            height: 64,
          ),
          applicationName: packageInfo.appName,
          applicationVersion: packageInfo.version,
          applicationLegalese: """
© 2020 Danny Lin (github.com/kdrag0n)
© 2024 mekomi (github.com/mekomidev)
          """,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(appDescription),
            ),
          ],
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    switch (_mode) {
      case Mode.PAINT:
        bodyWidget = PaintWidget(
          brushSize: _paintBrushSize,
          clearDelay: _paintClearDelay,
          showSampleRate: _showSampleRate,
          showEventPoints: _showEventPoints,
        );
        break;
      case Mode.FILL:
        bodyWidget = FillWidget();
        break;
      case Mode.FOLLOW:
        bodyWidget = FollowWidget(
          showSampleRate: _showSampleRate,
        );
        break;
      case Mode.BLANK:
        bodyWidget = BlankWidget();
        break;
    }

    final sampleRateText = _showSampleRate ? 'Hide sample rate' : 'Show sample rate';
    final eventPointsText = _showEventPoints ? 'Hide event points' : 'Show event points';

    return Scaffold(
      appBar: AppBar(
        title: Text('Touchpaint'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Mode',
            onPressed: _changeMode,
          ),
          IconButton(
            icon: Icon(Icons.brush),
            tooltip: 'Brush size',
            onPressed: _changeBrushSize,
          ),
          IconButton(
            icon: Icon(Icons.access_time),
            tooltip: 'Clear delay',
            onPressed: _changeClearDelay,
          ),
          PopupMenuButton<String>(
            onSelected: selectMenuItem,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: sampleRateText,
                child: Text(sampleRateText),
              ),
              PopupMenuItem<String>(
                value: eventPointsText,
                child: Text(eventPointsText),
              ),
              PopupMenuItem<String>(
                value: 'About',
                child: const Text('About'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black,
        child: bodyWidget,
      ),
    );
  }
}
