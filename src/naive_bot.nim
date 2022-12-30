import board, game

type
  Choice* = tuple[cardIndex: int, stackIndex: int, score: int]
  NaiveBot* = object of RootObj

proc scoreCard*(bot: NaiveBot, value: int, board: Board, stackIndex: int): int = 
  let stack: Stack = board.stacks[stackIndex]
  let top = stack.cards[stack.cards.len-1]
  case stack.dir:
    of dirAscending:
      if value == top - 10:
        return 0
      if value < top:
        return 999
      return value - top
    of dirDescending:
      if value == top + 10:
        return 0
      if value > top:
        return 999
      return top - value

proc chooseCard*(bot: NaiveBot, game: Game, player: Player): Choice =
  var bestScore = 100
  var choice = (cardIndex: -1, stackIndex: -1, score: bestScore)
  for cardIndex, value in player.cards:
    for stackIndex, stack in game.board.stacks:
      let score = bot.scoreCard(value, game.board, stackIndex)
      if score < bestScore:
        bestScore = score
        choice = (cardIndex: cardIndex, stackIndex: stackIndex, score: score)
  return choice

proc takeTurn*(bot: NaiveBot, game: var Game, player: var Player): bool =
  for i in countup(1, game.board.minPlay):
    var choice = bot.chooseCard(game, player)
    if choice.cardIndex == -1:
      return false
    player.playCard(choice.cardIndex, game, choice.stackIndex)
  player.drawCards(game)
  return true
