extends Node

signal moves_updated(moves)
signal debt_updated(debt)

const starting_moves : int = 50
const starting_debt : int = 900000

var moves_remaining : int = starting_moves :
    set(n):
        moves_remaining = n
        moves_updated.emit(n)

var debt_remaining : int = starting_debt :
    set(n):
        debt_remaining = n
        debt_updated.emit(n)

var active_contracts : Array[ContractData] = []
