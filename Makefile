config:
	@echo "Copying .config directory to $(HOME)/.config..."
	@mkdir -p $(HOME)/.config
	@cp -r .config/* $(HOME)/.config/
	@echo "Reloading i3..."
	-@i3-msg reload
	@echo "Done."

.PHONY: config save_local

save_local:
	@echo "Saving config from $(HOME)/.config to .config..."
	@mkdir -p .config
	@cp -r $(HOME)/.config/alacritty .config/
	@cp -r $(HOME)/.config/nvim .config/
	@cp -r $(HOME)/.config/i3 .config/
	@cp -r $(HOME)/.config/i3status .config/
	@cp -r $(HOME)/.config/rofi .config/
	@echo "Done."
