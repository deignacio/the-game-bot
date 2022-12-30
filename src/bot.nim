import sequtils
import board, game, game_stats
import naive_bot, more_than_min_turns_bot

type
  BotKind = enum
    NAIVE_BOT_KIND,
    MORE_THAN_MIN_TURNS_BOT_KIND

proc playGame*[Bot](bot: Bot, game: var Game): GameStats =
  while game.score < 102:
    var player: Player = game.currentPlayer
    let successful = bot.takeTurn(game, player)
    if not successful:
      break

  game.stats.won = game.score == 102
  game.stats.score = game.score
  return game.stats

proc playGame*(game: var Game, botKind: int): GameStats =
  if botKind > BotKind.high.ord:
    return

  let k: BotKind = BotKind.toSeq()[botKind]
  case k:
    of NAIVE_BOT_KIND:
      var b: NaiveBot = NaiveBot()
      return b.playGame(game)
    of MORE_THAN_MIN_TURNS_BOT_KIND:
      var b: MoreThanMinTurnsBot = MoreThanMinTurnsBot()
      return b.playGame(game)
