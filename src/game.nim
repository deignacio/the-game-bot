import math, sequtils, tables
import board, game_stats

type
  Player* = ref object
    cards*: seq[int]
  Game* = ref object
    board*: Board
    players: seq[Player]
    turn*: int
    stats*: GameStats

const CARD_COUNTS = {
  1: 8,
  2: 7,
  3: 6,
  4: 6,
  5: 6
}.toTable

proc newPlayer*(): Player =
  return Player(cards: newSeq[int]())

proc playCard*(p: var Player, cardIndex: int, g: var Game, stackIndex: int) =
  assert p.cards.len > cardIndex
  assert g.board.stacks.len > stackIndex

  var card: int = p.cards[cardIndex]
  var stack: Stack = g.board.stacks[stackIndex]
  case stack.dir:
    of dirAscending:
      assert card > stack.cards[stack.cards.len-1] or (card == stack.cards[stack.cards.len-1] - 10)
      if card == stack.cards[stack.cards.len-1] - 10:
        g.stats.upTens += 1
    of dirDescending:
      assert card < stack.cards[stack.cards.len-1] or (card == stack.cards[stack.cards.len-1] + 10)
      if card == stack.cards[stack.cards.len-1] + 10:
        g.stats.downTens += 1

  # validations have passed, go ahead and do it
  p.cards.delete(cardIndex..cardIndex)
  g.board.stacks[stackIndex].cards.add(card)

proc drawCards*(p: Player, g: Game) =
  let toDraw = CARD_COUNTS.getOrDefault(g.players.len, 6) - p.cards.len
  for i in countup(1, toDraw):
    let card = g.board.drawCard()
    if card > 0:
      p.cards.add(card)

proc newGame*(numPlayers: int, seed: int64): Game =
  var b: Board = newBoard(seed)
  var players: seq[Player] = newSeqWith(numPlayers, newPlayer())

  # create games
  var g: Game = Game(
    board: b,
    players: players,
    turn: 0
  )

  # draw the initial hands
  players.apply(proc (p: var Player) =
    p.drawCards(g)
  )

  return g  

proc currentPlayer*(g: Game): Player =
  let index = floorMod(g.turn, g.players.len)
  result = g.players[index]
  g.turn += 1

proc score*(g: Game): int =
  return g.board.score

proc dump*(p: Player) =
  echo "Player: ", p.cards

proc dump*(g: Game) =
  echo "Game: "
  dump(g.board)
  for player in g.players:
    dump(player)
