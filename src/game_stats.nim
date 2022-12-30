import sequtils, stats

type
  GameStats* = tuple[won: bool, upTens: int, downTens: int, extraCards: int, score: int]

proc dump*(stats: seq[GameStats]) =
  var scoreStats: RunningStat
  var upTenStats: RunningStat
  var downTenStats: RunningStat
  var winUpTenStats: RunningStat
  var winDownTenStats: RunningStat
  var extraCardStats: RunningStat
  for gameStat in stats:
    scoreStats.push(gameStat.score)
    upTenStats.push(gameStat.upTens)
    downTenStats.push(gameStat.downTens)
    extraCardStats.push(gameStat.extraCards)
    if gameStat.won:
      winUpTenStats.push(gameStat.upTens)
      winDownTenStats.push(gameStat.downTens)
  echo "Games run: ", stats.len
  let wins = stats.countIt(it.won == true)
  echo "Wins: ", wins, " (", 100 * wins / stats.len, "%)"
  echo "\tUp-tens: ", int(winUpTenStats.sum), "\n\t\tmean: ", winUpTenStats.mean, "\tstd-dev: ", winUpTenStats.standardDeviation
  echo "\tDown-tens: ", int(winDownTenStats.sum), "\n\t\tmean: ", winDownTenStats.mean, "\tstd-dev: ", winDownTenStats.standardDeviation
  echo "Score mean: ", scoreStats.mean, "\n\tstd-dev: ", scoreStats.standardDeviation
  echo "\tUp-tens: ", int(upTenStats.sum), "\n\t\tmean: ", upTenStats.mean, "\tstd-dev: ", upTenStats.standardDeviation
  echo "\tDown-tens: ", int(downTenStats.sum), "\n\t\tmean: ", downTenStats.mean, "\tstd-dev: ", downTenStats.standardDeviation
  echo "Turns with extra cards: ", extraCardStats.mean, "\n\tstd-dev: ", extraCardStats.standardDeviation

proc csv*(stats: seq[GameStats], path: string) =
  if path.len == 0:
    return
  echo "going to drop a csv at ", path
  let byTens: seq[int] = stats.mapIt(it.upTens + it.downTens)
  let byScore: seq[int] = stats.mapIt(it.score)
  let extraTurns: seq[int] = stats.mapIt(it.extraCards)
  let file = open(path, fmWrite)
  for i in countup(0, byTens.len-1):
    file.write(byTens[i])
    file.write("\t")
    file.write(byScore[i])
    file.write("\t")
    file.write(extraTurns[i])
    file.write("\n")
  file.close()
