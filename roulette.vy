players: address[420]
plays: HashMap[address, bool]
lost: HashMap[address, bool]
odds: uint256
playersTurn: uint256
creator: address
playerLength: uint256

@external
def __init__():
    self.playerLength = 0
    self.odds = 0
    self.playersTurn = 0
    self.creator = msg.sender
    self.odds = 6

@external
def setOdds(odd: uint256):
    assert odd > 0
    assert self.creator == msg.sender
    self.odds = odd

@external
def addPlayer(player: address):
    assert player != empty(address)
    assert self.plays[player] == False
    assert self.lost[player] == False
    self.players[self.playerLength] = player
    self.playerLength += 1
    self.plays[player] = True

@internal
def lose(player: address):
    assert player != empty(address)
    assert self.plays[player] == True
    assert self.lost[player] == False
    for i in range(420):
        if i >= self.playerLength:
            break
        self.plays[self.players[i]] = empty(bool)
        self.players[i] = empty(address)
    self.playerLength = 0
    self.playersTurn = 0
    self.lost[player] = True

    log Eliminated(player, block.timestamp)

@internal
def random() -> uint256:
    return block.timestamp % self.odds

@external
def play():
    choice: uint256 = self.random()
    nPlayer: address = self.players[self.playersTurn]
    if choice == 0:
        self.lose(nPlayer)
    else:
        self.playersTurn += 1
        self.playersTurn = self.playersTurn % self.playerLength
        log Survivor(nPlayer, block.timestamp)

@external
def isALoser(player: address) -> bool:
    assert player != empty(address)
    return self.lost[player] == True

event Eliminated:
    ePlayer: indexed(address)
    eTimestamp: uint256

event Survivor:
    sPlayer: indexed(address)
    sTimestamp: uint256
    
