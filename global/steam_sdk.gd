extends Node
var OWNED = false
var ONLINE = false
var STEAM_ID = 0

#setAchievement
#func init_steam_sdk():
#	var INIT = Steam.steamInit()
#	print("steam_init: "+str(INIT))
#
#	if INIT['status'] != 0:
#		print("Failed to initialize Steam. "+str(INIT['verbal'])+" Shutting down...")
#		get_tree().quit()
#
#
#	ONLINE = Steam.loggedOn()
#	STEAM_ID = Steam.getSteamID()
#	OWNED = Steam.isSubscribed()
#
#	print("steam_id: ",STEAM_ID)
#	print("steam_online: ",ONLINE)
#	if OWNED == false:
#		print("User does not own this game")
#		get_tree().quit()
#	Steam.run_callbacks()
#func _ready():
#	init_steam_sdk()
func setAchievement(name_):
	pass
#	Steam.setAchievement("First_blood")
