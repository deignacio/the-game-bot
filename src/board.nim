import random, sequtils

type
  # I don't know how to do types of range
  # Card = range(2, 99)
  Direction* = enum
    dirAscending, dirDescending
  Stack* = ref object
    dir*: Direction
    cards*: seq[int]
  Board* = ref object
    stacks*: seq[Stack]
    # private things after this?
    seed: int64
    rand: Rand
    deck: seq[int]

proc drawCard*(b: var Board): int =
  if b.deck.len > 0:
    return b.deck.pop()
  return -1

proc score*(b: Board): int =
  for len in b.stacks.mapIt(it.cards.len):
    result += len

proc minPlay*(b: Board): int =
  if b.deck.len > 0:
    return 2
  return 1

proc newStack(dir: Direction): Stack =
  var s = Stack(dir:dir, cards: newSeq[int]())
  case dir:
    of dirAscending:
      s.cards.add(1)
    of dirDescending:
      s.cards.add(100)
  return s

proc newBoard*(seed: int64): Board =
  var r = initRand(seed)
  var d: seq[int] = toSeq(countup(2, 99))
  r.shuffle(d)

  return Board(
    stacks: @[
      newStack(dirAscending),
      newStack(dirAscending),
      newStack(dirDescending),
      newStack(dirDescending)
    ],
    seed: seed,
    deck: d
  )

proc dump*(s: Stack) =
  echo "Stack: ", s.dir
  echo "\t", s.cards

proc dump*(b: Board) =
  echo "Board:"
  for stack in b.stacks:
    dump(stack)
  echo ""
