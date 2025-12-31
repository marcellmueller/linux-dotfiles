config:
	@echo "Copying .config directory to $(HOME)/.config..."
	@mkdir -p $(HOME)/.config
	@cp -r .config/* $(HOME)/.config/
	@echo "Reloading i3..."
	-@i3-msg reload
	@echo "Done."

.PHONY: config
