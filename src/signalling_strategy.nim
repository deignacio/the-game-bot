import tables
import board, game
import naive_strategy

type
  SignallingStrategy* = object of NaiveStrategy
  SignalStrength* = enum
    signalNone,
    signalWeak,
    signalStrong
  StackSignal* = tuple[strength: SignalStrength, stackIndex: int]

const SignalStrengthAdjustment = [
  signalNone: 0,
  signalWeak: 3,
  signalStrong: 10
]

proc stackSignals(strat: NaiveStrategy, board: Board, player: Player): seq[StackSignal] =
  var signals: seq[StackSignal] = newSeq[StackSignal]()
  for cardIndex, value in player.cards:
    for stackIndex, stack in board.stacks:
      let score = strat.scoreCard(value, board, stackIndex)
      if score == 0:
        signals.add((strength: signalStrong, stackIndex: stackIndex))
      elif score <= 3:
        signals.add((strength: signalWeak, stackIndex: stackIndex))
  return signals

proc allSignals(strat: NaiveStrategy, game: Game, current: Player): Table[int, SignalStrength] =
  var byStack: Table[int, SignalStrength] = initTable[int, SignalStrength]()
  for player in game.players:
    if player == current:
      continue
    let forPlayer = strat.stackSignals(game.board, player)
    for signal in forPlayer:
      if signal.strength != signalNone:
        if not byStack.contains(signal.stackIndex) or 
          SignalStrengthAdjustment[signal.strength] > SignalStrengthAdjustment[byStack[signal.stackIndex]]:
          byStack[signal.stackIndex] = signal.strength
  return byStack

proc chooseCard*(strat: NaiveStrategy, game: Game, player: Player, signals: Table[int, SignalStrength]): Choice =
  var bestScore = 100
  var choice = (cardIndex: -1, stackIndex: -1, score: bestScore)
  for cardIndex, value in player.cards:
    for stackIndex, stack in game.board.stacks:
      let score = strat.scoreCard(value, game.board, stackIndex)
      if score == 0:
        bestScore = score
        choice = (cardIndex: cardIndex, stackIndex: stackIndex, score: score)
      elif signals.contains(stackIndex):
        let adjusted = score + SignalStrengthAdjustment[signals[stackIndex]]
        if adjusted < bestScore:
          bestScore = adjusted
          choice = (cardIndex: cardIndex, stackIndex: stackIndex, score: adjusted)
      elif score < bestScore:
          bestScore = score
          choice = (cardIndex: cardIndex, stackIndex: stackIndex, score: score)
  return choice

proc takeTurn*(strat: SignallingStrategy, game: var Game, player: var Player): bool =
  for i in countup(1, game.board.minPlay):
    let signals = strat.allSignals(game, player)
    var choice = strat.chooseCard(game, player, signals)
    if choice.cardIndex == -1:
      return false
    player.playCard(choice.cardIndex, game, choice.stackIndex)
  let signals = strat.allSignals(game, player)
  var choice = strat.chooseCard(game, player, signals)
  if choice.score == 0:
    game.stats.extraCards += 1
    player.playCard(choice.cardIndex, game, choice.stackIndex)
  player.drawCards(game)
  return true
