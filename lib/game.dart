import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
	
	String playerName;
	
	GameScreen({@required this.playerName}) :
			assert(playerName != null);
	
	@override
	GameScreenState createState() => GameScreenState();
}


class GameScreenState extends State<GameScreen> {
	
	String winner;
	String message = 'Your turn';
	String buttonMessage = 'Give up now !';
	
	List<List<ButtonValue>> values = [
		for (int i=0; i<3; i++)
			[
				for (int j=0; j<3; j++)
					ButtonValue()
			]
	];
	
	// @override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Let\'s play, ${widget.playerName} !!!'),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
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
										for (int i=0; i<3; i++)
											Row(
												mainAxisAlignment: MainAxisAlignment.center,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													for (int j=0; j<3; j++)
														Padding(
															padding: EdgeInsets.all(2),
															child: InkWell(
																child: new Container(
																	width: 100.0,
																	height: 100.0,
																	decoration: new BoxDecoration(
																		color: Colors.blueAccent,
																		border: new Border.all(color: Colors.black, width: 2.0),
																		borderRadius: new BorderRadius.circular(10.0),
																	),
																	child: new Center(
																		child: new Text(values.elementAt(i).elementAt(j).value ?? '',
																			style: new TextStyle(fontSize: 75.0, color: Colors.white),
																		),
																	),
																),
																onTap: () => setState(() {
																	if (winner == null) {
																		if (values.elementAt(i).elementAt(j).value == null) {
																			values.elementAt(i).elementAt(j).value = "X";
																			playCpu();
																		}
																	}
																}),
															),
														)
												],
											)
									],
								),
							),
						),
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Padding(
									padding: EdgeInsets.only(bottom: 20, left: 120),
									child:
										Column(
											crossAxisAlignment: CrossAxisAlignment.end,
											mainAxisAlignment: MainAxisAlignment.end,
											children: [
												Padding(
													padding: EdgeInsets.only(bottom: 10),
													child: Text(message,
														style: TextStyle(fontSize: 20),
													),
												),
												
												RaisedButton(
													child: Padding(
														padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
														child: Text(
															buttonMessage,
															style: TextStyle(
																color: Colors.white
															),
														),
													),
													color: Colors.blue,
													onPressed: () {
														if (winner == null || winner == 'O')
															Navigator.pop(context, false);
														else if (winner == 'X')
															Navigator.pop(context, true);
														else if (winner == '-')
															Navigator.pop(context, null);
													},
												),
											],
										),
								),
							],
						),
					],
				),
			),
		);
	}
	
	void playCpu() {
		winner = getWinner();
		if (winner == null) {
			List<ButtonValue> unpressedButtons = [];
			for (var buttonList in values)
				for (var button in buttonList)
					if (button.value == null)
						unpressedButtons.add(button);
			
			if (unpressedButtons.isNotEmpty) {
				var button = unpressedButtons.elementAt(new Random().nextInt(unpressedButtons.length));
				setState(() {
					button.value = 'O';
				});
				
				winner = getWinner();
			} else {
				winner = '-';
			}
		}
		
		if (winner != null) {
			setState(() {
				if (winner == '-') {
					message = 'It\'s a tie';
					buttonMessage = 'Go back';
				} else if (winner == 'X') {
					message = 'You got lucky this time';
					buttonMessage = 'Return in glory';
				} else if (winner == 'O') {
					message = 'Better luck next time';
					buttonMessage = 'Retreat in shame';
				}
			});
		}
	}
	
	String getWinner() {
		for (int i = 0; i < 3; i++) {
			if (values.elementAt(i).elementAt(0).value == values.elementAt(i).elementAt(1).value
					&& values.elementAt(i).elementAt(0).value == values.elementAt(i).elementAt(2).value)
				return values.elementAt(i).elementAt(0).value;
			
			
			if (values.elementAt(0).elementAt(i).value == values.elementAt(1).elementAt(i).value
				&& values.elementAt(0).elementAt(i).value == values.elementAt(2).elementAt(i).value)
				return values.elementAt(0).elementAt(i).value;
			
			if (values.elementAt(0).elementAt(0).value == values.elementAt(1).elementAt(1).value
				&& values.elementAt(0).elementAt(0).value == values.elementAt(2).elementAt(2).value)
				return values.elementAt(0).elementAt(0).value;
			
			if (values.elementAt(0).elementAt(2).value == values.elementAt(1).elementAt(1).value
				&& values.elementAt(0).elementAt(2).value == values.elementAt(2).elementAt(0).value)
				return values.elementAt(0).elementAt(2).value;
		}
		return null;
	}
	
}


class ButtonValue {
	String value;
}

