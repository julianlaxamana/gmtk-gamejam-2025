extends Node

var cursorGrab = false
var inventory = []
var editor
var disableMouse = false

var selectedUnit
var unitScripts = {
}

var path_node
var battlefield
var grid

const BUG_SPRITE_DICTIONARY = {
	"meep": {
		"DR": preload("res://Assets/Bugs/meep.png"),
		"DL": preload("res://Assets/Bugs/meep.png"),
		"UL": preload("res://Assets/Bugs/meep.png"),
		"UR": preload("res://Assets/Bugs/meep.png")},
	"fob": {
		"DR": preload("res://Assets/Bugs/meep.png"),
		"DL": preload("res://Assets/Bugs/meep.png"),
		"UL": preload("res://Assets/Bugs/meep.png"),
		"UR": preload("res://Assets/Bugs/meep.png")},
	"borf": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"spoid": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"tiny_spoid": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"bleep": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"zonk": {
		"DR": preload("res://Assets/Bugs/zonk.png"),
		"DL": preload("res://Assets/Bugs/zonk.png"),
		"UL": preload("res://Assets/Bugs/zonk.png"),
		"UR": preload("res://Assets/Bugs/zonk.png")},
	"lez_tail": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"lez_middle": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"lez_head": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
	"smorg": {
		"DR": preload("res://Assets/Bugs/bug_basic.png"),
		"DL": preload("res://Assets/Bugs/bug_basic.png"),
		"UL": preload("res://Assets/Bugs/bug_basic.png"),
		"UR": preload("res://Assets/Bugs/bug_basic.png")},
}
