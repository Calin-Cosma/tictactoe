import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:tictactoe/game.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await PrefService.init();
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Tic Tac Toe',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: MyHomePage(title: 'Tic Tac Toe'),
		);
	}
}

class MyHomePage extends StatefulWidget {
	MyHomePage({Key key, this.title}) : super(key: key);

	final String title;
	String playerName = PrefService.getString('player.name');
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
										Padding(
											padding: EdgeInsets.only(left: 100),
											child: Text('Powered by Flutter'),
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
													Text(widget.playerName ?? 'You',
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
		if (widget.playerName == null) {
			var _username = await _showUsernameDialog();
			if (_username != null) {
				setState(() {
					PrefService.setString('player.name', _username);
					widget.playerName = _username;
				});
			}
		}
		
		if (widget.playerName != null) {
			final playerWon = await Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => GameScreen(playerName: widget.playerName)),
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
						FlatButton(
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
