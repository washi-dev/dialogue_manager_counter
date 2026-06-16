@tool
extends EditorPlugin

var dock: Control = null
var text_edit: CodeEdit = null
var main_view: Control = null

func _enter_tree():
	connect("main_screen_changed", Callable(self, "_on_main_screen_changed"))
	_register_project_settings()

func _register_project_settings():
	if not ProjectSettings.has_setting("dialogue_manager_counter/general/max_line_length"):
		ProjectSettings.set_setting("dialogue_manager_counter/general/max_line_length", 35)
	ProjectSettings.add_property_info({
		"name": "dialogue_manager_counter/general/max_line_length",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,200,1"
	})

func _exit_tree():
	if dock:
		remove_control_from_docks(dock)
		dock.queue_free()
		dock = null

	if text_edit and text_edit.is_connected("caret_changed", Callable(self, "_on_caret_changed")):
		text_edit.disconnect("caret_changed", Callable(self, "_on_caret_changed"))
		text_edit = null

	main_view = null

func _on_main_screen_changed(screen_name: String):
	if screen_name.to_lower() == "dialogue":
		if dock == null:
			dock = preload("res://addons/dialogue_manager_counter/dialogue_manager_counter.tscn").instantiate()
			add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)

		_update_text_edit()
		_update_main_view()
		_update_line_length()


func _update_text_edit():
	text_edit = null
	text_edit = _find_dm_code_edit(get_tree().get_root())

	if text_edit:
		if not text_edit.is_connected("caret_changed", Callable(self, "_on_caret_changed")):
			text_edit.connect("caret_changed", Callable(self, "_on_caret_changed"))
		# テキスト変更時にも全体文字数を更新
		if not text_edit.is_connected("text_changed", Callable(self, "_on_text_changed")):
			text_edit.connect("text_changed", Callable(self, "_on_text_changed"))
	else:
		print("❌ DMCodeEdit not found")

func _update_main_view():
	main_view = _find_main_view(get_tree().get_root())
	if not main_view:
		print("❌ MainView not found")

func _on_caret_changed():
	_update_line_length()

func _on_text_changed():
	_update_total_length()

func _update_line_length():
	if not text_edit or not dock:
		return

	if text_edit.has_method("get_line") and text_edit.has_method("get_caret_line"):
		var line := text_edit.get_line(text_edit.get_caret_line())

		# RegExインスタンスを明示的に作成
		var regex: RegEx = RegEx.new()
		regex.compile("\\[.*?\\]")  # 非貪欲マッチで [～] を除去
		var cleaned_line: String = regex.sub(line, "", true)

		# 現在のファイルがHシーンかどうかを判定
		var is_h_scene := _is_h_scene_file()
		dock.update_line_length(cleaned_line, is_h_scene)

		# 全体文字数を更新（すべてのdialogueファイルで表示）
		_update_total_length()
	else:
		print("⚠ text_edit does not support expected methods")

func _update_total_length():
	if not text_edit or not dock:
		return

	var full_text := text_edit.text
	var total_count := _count_dialogue_characters(full_text)
	dock.update_total_length(total_count)

func _is_h_scene_file() -> bool:
	if not main_view:
		return false

	var current_file_path: String = main_view.get("current_file_path")
	if current_file_path == null or current_file_path == "":
		return false

	var file_name := current_file_path.get_file()
	return file_name.begins_with("h_")

func _count_dialogue_characters(text: String) -> int:
	var total := 0
	var lines := text.split("\n")

	# 制御タグを除去するための正規表現
	var tag_regex := RegEx.new()
	tag_regex.compile("\\[.*?\\]")

	# 話者形式を除去するための正規表現
	var speaker_regex := RegEx.new()
	speaker_regex.compile("^[^:：]{1,10}[:：]\\s?")

	for line in lines:
		var trimmed := line.strip_edges()

		# 無視する行：空行、#、~、=>、do で始まる行
		if trimmed == "":
			continue
		if trimmed.begins_with("#") or trimmed.begins_with("~") or trimmed.begins_with("=>") or trimmed.begins_with("do"):
			continue
		if trimmed.begins_with("-"):  # 選択肢
			continue
		if trimmed.begins_with("if ") or trimmed.begins_with("elif ") or trimmed.begins_with("else"):
			continue
		if trimmed.begins_with("set "):
			continue

		# 制御タグを除去
		var cleaned := tag_regex.sub(trimmed, "", true)

		# 話者名を除去
		var match := speaker_regex.search(cleaned)
		if match:
			cleaned = cleaned.substr(match.get_end())

		# \n（文字列内のエスケープ）で分割して各行をカウント
		var sub_lines := cleaned.split("\\n")
		for sub_line in sub_lines:
			var sub_trimmed := sub_line.strip_edges()
			if sub_trimmed != "":
				total += sub_trimmed.length()

	return total

func _find_dm_code_edit(node: Node) -> CodeEdit:
	for child in node.get_children():
		if child is CodeEdit and child.get_script():
			var path = child.get_script().resource_path
			if path.contains("code_edit.gd"):  # 実際のファイル名に調整
				return child
		var found = _find_dm_code_edit(child)
		if found:
			return found
	return null

func _find_main_view(node: Node) -> Control:
	for child in node.get_children():
		if child.get_script():
			var path = child.get_script().resource_path
			if path.contains("main_view.gd"):
				return child
		var found = _find_main_view(child)
		if found:
			return found
	return null
