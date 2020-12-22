# Creates a GridContainer in which cards can be placed organized next
# to each other.
#
# To use this scene properly, create an inherited scene,
# then add as many instanced BoardPlacementSlots as you need this grid to hold
#
# Adjust its highlight colour and the amount of columns it should have as well
#
# The BoardPlacementSlots will adjust to CFConst.CARD_SIZE on runtime, but
# If you want to visually see on the editor your result
class_name BoardPlacementGrid
extends Control

# Used to add new BoardPlacementSlot instances to grids. We have to add the consts
# together before passing to the preload, or the parser complains
const _SLOT_SCENE_FILE = CFConst.PATH_CORE + "BoardPlacementSlot.tscn"
const _SLOT_SCENE = preload(_SLOT_SCENE_FILE)

# Set the highlight colour for all contained BoardPlacementSlot slots
export(Color) var highlight = CFConst.TARGET_HOVER_COLOUR

# Sets a custom label for this grid
onready var name_label = $Control/Label

func _ready() -> void:
	# We ensure the separation of the grid slots is always 1 pixel larger
	# Than the radius of the mouse pointer collision area.
	# This ensures that we don't highlight 2 slots at the same time.
	$GridContainer.set("custom_constants/vseparation", MousePointer.MOUSE_RADIUS * 2 + 1)
	$GridContainer.set("custom_constants/hseparation", MousePointer.MOUSE_RADIUS * 2 + 1)
	if not name_label.text:
		name_label.text = name


# If a BoardPlacementSlot object child in this container is highlighted
# Returns the object. Else returns null
func get_highlighted_slot() -> BoardPlacementSlot:
	var ret_slot: BoardPlacementSlot = null
	for slot in $GridContainer.get_children():
		if slot.is_highlighted():
			ret_slot = slot
	return(ret_slot)


# Returns the slot at the specified index.
func get_slot(idx: int) -> BoardPlacementSlot:
	var ret_slot: BoardPlacementSlot = $GridContainer.get_child(idx)
	return(ret_slot)


# Adds new placement slot to the grid.
# Returns the slot object
func add_slot() -> BoardPlacementSlot:
	var new_slot : BoardPlacementSlot = _SLOT_SCENE.instance()
	$GridContainer.add_child(new_slot)
	return(new_slot)


# Returns a slot that is not currently occupied by a card
func find_available_slot() -> BoardPlacementSlot:
	var found_slot : BoardPlacementSlot
	for slot in $GridContainer.get_children():
		if not slot.occupying_card:
			found_slot = slot
	return(found_slot)


# Returns an array containing all the BoardPlacementSlots
func get_all_slots() -> Array:
	return($GridContainer.get_children())


# Returns the amount of BoardPlacementSlot contained. 
func get_slot_count() -> int:
	return(get_all_slots().size())
