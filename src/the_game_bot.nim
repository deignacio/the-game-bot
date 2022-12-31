import parseopt, strutils, times
import game, game_stats, strategy

proc buildGame(): Game =
  var numPlayers = 1
  let now = getTime()
  var randSeed = now.toUnix * 1_000_000_000 + now.nanosecond
  for _, key, val in getopt():
    if key == "n":
      numPlayers = parseInt(val)
    if key == "r":
      randSeed = parseInt(val)
  return newGame(numPlayers, randSeed)

proc runGame(): GameStats =
  var g: Game = buildGame()
  var stratKind = 0  
  var quiet = false
  for _, key, val in getopt():
    if key == "q":
      quiet = true
    if key == "s":
      stratKind = parseInt(val)
  let gStats = g.playGame(stratKind)
  if not quiet:
    dump(g)
  return gStats

proc iterationCount(): int =
  result = 1
  for _, key, val in getopt():
    if key == "i":
      result = parseInt(val)

proc csvPath(): string =
  for _, key, val in getopt():
    if key == "c":
      return val
  return ""

when isMainModule:
  echo "Welcome to The Game Bot"
  var gStats = newSeq[GameStats]()
  for i in countup(1, iterationCount()):
    gStats.add(runGame())
  gStats.dump()
  gStats.csv(csvPath())
