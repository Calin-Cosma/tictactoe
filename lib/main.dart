import 'package:flutter/material.dart';
import 'package:pref/pref.dart';
import 'package:tictactoe/game.dart';
import 'package:url_launcher/url_launcher.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await PrefService.init();
    final service = await PrefServiceShared.init(
  	    defaults: {
            'player.name': '',
            // 'ui_theme': 'light',
        },
    );
    // runApp(MyApp(service: service));
    runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
    final BasePrefService service;

    MyApp({required this.service});

    @override
    Widget build(BuildContext context) {
        return PrefService(
            service: service,
            child: MaterialApp(
                title: 'Tic Tac Toe',
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                ),
                home: MyHomePage(title: 'Tic Tac Toe'),
            ),
        );
    }
}

class MyHomePage extends StatefulWidget {
    MyHomePage({Key? key, required this.title}) : super(key: key);

    final String title;
    int playerScore = 0;
    int cpuScore = 0;

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 32, bottom: 8),
                                            child: Text(
                                                'TIC TAC TOE',
                                                style: TextStyle(
                                                        fontSize: 45, fontWeight: FontWeight.bold),
                                            ),
                                        ),
                                        Column(
                                            children: [
                                                Text('Powered by Flutter'),
                                                GestureDetector(
                                                    onTap: () async {
                                                        final url = Uri.parse('https://calincosma.com');
                                                        if (await canLaunchUrl(url)) {
                                                            await launchUrl(
                                                                url,
                                                                mode: LaunchMode.externalApplication,
                                                            );
                                                        }
                                                    },
                                                    child: Text(
                                                        'Created by Calin',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            decoration: TextDecoration.underline,
                                                        ),
                                                    ),
                                                ),
                                            ],
                                        ),

                                    ],
                                ),
                            ],
                        ),
                        Expanded(
                            child: Center(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Padding(
                                            padding: EdgeInsets.only(left: 80, right: 80, bottom: 20),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text(PrefService.of(context).get<String>('player.name') ?? 'You',
                                                            style: TextStyle(
                                                                    fontSize: 35, fontWeight: FontWeight.bold)),
                                                    Text('CPU',
                                                            style: TextStyle(
                                                                    fontSize: 35, fontWeight: FontWeight.bold)),
                                                ],
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 40, right: 40),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 60),
                                                        child: Text('${widget.playerScore}',
                                                                style: TextStyle(
                                                                        fontSize: 35, fontWeight: FontWeight.bold)),
                                                    ),
                                                    Text('-',
                                                            style: TextStyle(
                                                                    fontSize: 35, fontWeight: FontWeight.bold)),
                                                    Padding(
                                                        padding: EdgeInsets.only(right: 60),
                                                        child: Text('${widget.cpuScore}',
                                                                style: TextStyle(
                                                                        fontSize: 35, fontWeight: FontWeight.bold)),
                                                    )
                                                ],
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ),    
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: _play,
                tooltip: 'Play new game',
                child: Icon(Icons.play_arrow),
            ),
        );
    }

    void _play() async {
        if (PrefService.of(context).get<String>('player.name')!.isEmpty) {
            var _username = await _showUsernameDialog();
            if (_username != null) {
                setState(() {
                    PrefService.of(context).set('player.name', _username);
                });
            }
        }
        
        if (PrefService.of(context).get<String>('player.name')!.isNotEmpty) {
            final playerWon = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameScreen(playerName: PrefService.of(context).get<String>('player.name') ?? '')),
            );
            setState(() {
                if (playerWon != null)
                    if (playerWon)
                        widget.playerScore++;
                    else
                        widget.cpuScore++;
                else {
                    widget.playerScore++;
                    widget.cpuScore++;
                }
            });
        }
    }
    
    
    Future<String> _showUsernameDialog() async {
        String _username = '';
        await showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('What is your name ?'),
                    content: TextFormField(
                        initialValue: _username,
                        onChanged: (newValue) {
                            _username = newValue;
                        },
                    ),
                    actions: <Widget>[
                        TextButton(
                            child: Text('Save'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
        
        return _username;
    }
}
