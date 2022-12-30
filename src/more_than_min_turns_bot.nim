import board, game
import naive_bot

type
  MoreThanMinTurnsBot* = object of NaiveBot

proc takeTurn*(bot: MoreThanMinTurnsBot, game: var Game, player: var Player): bool =
  for i in countup(1, game.board.minPlay):
    var choice = bot.chooseCard(game, player)
    if choice.cardIndex == -1:
      return false
    player.playCard(choice.cardIndex, game, choice.stackIndex)
  # This doesn't actually work, but will eventually
  var choice = bot.chooseCard(game, player)
  if choice.cardIndex == -1 and choice.score == 0:
    game.stats.extraCards += 1
    player.playCard(choice.cardIndex, game, choice.stackIndex)
  player.drawCards(game)
  return true
