extends Node

const starting_moves : int = 50
const starting_bounty : int = 900000

var moves_remaining : int = starting_moves
var active_contracts : Array[ContractData] = []
