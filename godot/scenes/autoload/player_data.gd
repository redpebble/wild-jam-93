extends Node

signal moves_updated(moves)
signal debt_updated(debt)

signal game_won
signal game_lost

const starting_moves : int = 10 # TESTING
const starting_debt : int = 100000

var state_updated: bool = false
var moves_remaining: int = starting_moves
var debt_remaining: int = starting_debt

var active_contracts : Array[ContractData] = []

func take_move(n = 1) -> void:
	moves_remaining -= n
	moves_updated.emit(moves_remaining)
	if not state_updated:
		call_deferred("check_end_state")
	state_updated = true

func reduce_debt(amount) -> void:
	debt_remaining -= amount
	debt_updated.emit(debt_remaining)
	if not state_updated:
		call_deferred("check_end_state")
	state_updated = true

func check_end_state() -> void:
	state_updated = false
	if debt_remaining <= 0:
		game_won.emit()
	elif moves_remaining <= 0:
		game_lost.emit()

func reset() -> void:
	state_updated = false
	moves_remaining = starting_moves
	debt_remaining = starting_debt
