extends Label

var collectedgrammar = " Items"
var collected = 0
var collectibles = 0
var wordorder = 0

signal level_won

func _enter_tree():
	if TranslationServer.get_locale().find("nl") != -1:
		wordorder = 1

func _update_collect():
	if get_node("/root/Global/Vars").collected == 1:
		collectedgrammar = " " + tr("i18n_hud_ITEM")
	else:
		collectedgrammar = " " + tr("i18n_hud_ITEMS")
	if wordorder == 1:
		set_text(str(get_node("/root/Global/Vars").collected)
		+ " " + tr("i18n_hud_OF") + " " + str(get_node("/root/Global/Vars").collectibles) + collectedgrammar
		+ " " + tr("i18n_hud_COLLECTED"))
	else:
		set_text(tr("i18n_hud_COLLECTED") + " " + str(get_node("/root/Global/Vars").collected)
		+ collectedgrammar + " " + tr("i18n_hud_OF") + " " + str(get_node("/root/Global/Vars").collectibles))
	
	if get_node("/root/Global/Vars").collected == get_node("/root/Global/Vars").collectibles:
		# Trigger winscherm
		level_won.connect($/root/World/Egg/Egg._level_won)
		emit_signal("level_won")
