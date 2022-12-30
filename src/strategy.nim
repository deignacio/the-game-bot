import sequtils
import board, game, game_stats
import naive_strategy, more_than_min_turns_strategy

type
  StrategyKind = enum
    NAIVE_STRATEGY_KIND,
    MORE_THAN_MIN_TURNS_STRATEGY_KIND

proc playGame*[Strategy](strat: Strategy, game: var Game): GameStats =
  while game.score < 102:
    var player: Player = game.currentPlayer
    let successful = strat.takeTurn(game, player)
    if not successful:
      break

  game.stats.won = game.score == 102
  game.stats.score = game.score
  return game.stats

proc playGame*(game: var Game, stratKind: int): GameStats =
  if stratKind > StrategyKind.high.ord:
    return

  let k: StrategyKind = StrategyKind.toSeq()[stratKind]
  case k:
    of NAIVE_STRATEGY_KIND:
      var strat: NaiveStrategy = NaiveStrategy()
      return strat.playGame(game)
    of MORE_THAN_MIN_TURNS_STRATEGY_KIND:
      var strat: MoreThanMinTurnsStrategy = MoreThanMinTurnsStrategy()
      return strat.playGame(game)
