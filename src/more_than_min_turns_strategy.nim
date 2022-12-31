import board, game
import naive_strategy

type
  MoreThanMinTurnsStrategy* = object of NaiveStrategy

proc takeTurn*(strat: MoreThanMinTurnsStrategy, game: var Game, player: var Player): bool =
  for i in countup(1, game.board.minPlay):
    var choice = strat.chooseCard(game, player)
    if choice.cardIndex == -1:
      return false
    player.playCard(choice.cardIndex, game, choice.stackIndex)
  var choice = strat.chooseCard(game, player)
  if choice.score == 0:
    game.stats.extraCards += 1
    player.playCard(choice.cardIndex, game, choice.stackIndex)
  player.drawCards(game)
  return true
