extends Node

signal moves_updated(moves)
signal debt_updated(debt)

signal game_won
signal game_lost

const starting_moves : int = 3 # TESTING
const starting_debt : int = 69420

var moves_remaining : int = starting_moves :
	set(n):
		moves_remaining = n
		moves_updated.emit(n)
		checkGameEnd()

var debt_remaining : int = starting_debt :
	set(n):
		debt_remaining = n
		debt_updated.emit(n)
		checkGameEnd()

var active_contracts : Array[ContractData] = []

func checkGameEnd() -> void:
	if debt_remaining <= 0:
		game_won.emit()
	elif moves_remaining <= 0:
		game_lost.emit()

func reset() -> void:
	moves_remaining = starting_moves
	debt_remaining = starting_debt
