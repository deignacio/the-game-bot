# The Game Bot

## Usage
Build the thing
```
% nimble build
  Verifying dependencies for the_game_bot@0.1.0
   Building the_game_bot/the_game_bot using c backend
```

Run with default parameters, verbose (outputs players and end board), 1 iteration, 1 player, using naive bot
```
% ./bin/the_game_bot
Welcome to The Game Bot
Game:
Board:
Stack: dirAscending
	@[1, 10, 16, 26, 33, 40, 42, 43, 44, 46, 49, 50, 54, 55, 57, 76, 83, 88, 94, 98, 99]
Stack: dirAscending
	@[1, 8, 18, 19, 22, 28, 37, 38, 39, 51, 74, 95]
Stack: dirDescending
	@[100, 85, 84, 78, 71, 68, 67, 65, 59, 69, 30, 24, 14, 7, 6, 4, 3]
Stack: dirDescending
	@[100, 96, 91, 90, 82, 92, 89, 77, 72, 63, 35, 34, 31, 41, 36, 29, 25, 17, 9]

Player: @[70, 58, 93, 48, 64, 21, 87]
Games run: 1
Wins: 0 (0.0%)
	Up-tens: 0
		mean: 0.0	std-dev: nan
	Down-tens: 0
		mean: 0.0	std-dev: nan
Score mean: 69.0
	std-dev: 0.0
	Up-tens: 0
		mean: 0.0	std-dev: 0.0
	Down-tens: 3
		mean: 3.0	std-dev: 0.0
Turns with extra cards: 0.0
	std-dev: 0.0
```

Run quiet, 10000 iterations, 2 players, using bot 1 (trivial fork of naive bot), dumping tens, score, and turns with extra cards into a csv
```
% ./bin/the_game_bot -q -i:10000 -n:2 -b:1 -c:./output/data.csv
Welcome to The Game Bot
Games run: 10000
Wins: 192 (1.92%)
	Up-tens: 1347
		mean: 7.015624999999999	std-dev: 2.718525493604023
	Down-tens: 1340
		mean: 6.979166666666665	std-dev: 2.404332749895949
Score mean: 83.25690000000029
	std-dev: 11.67351285560606
	Up-tens: 37956
		mean: 3.795599999999999	std-dev: 2.352152342005086
	Down-tens: 37094
		mean: 3.709399999999985	std-dev: 2.320592950088402
Turns with extra cards: 0.0
	std-dev: 0.0
going to drop a csv at ./output/data.csv
```

## TODO

* I wanted to try to create a scatter plot using `ggplotnim`, but I couldn't get libcairo to work on my mac. Instead, I am just dumping to `csv` and using Google Sheets to visualize.
* I want to add a bunch of more bots with more nuanced strategy.
