scripts := ${ZK_NOTEBOOK_DIR}/.zk/scripts/

install:
	@mkdir -p "$(scripts)"
	@cp sketch.sh "$(scripts)"
	@cp sketch.scpt "$(scripts)"
	@echo "Installed"

uninstall:
	@rm -rf "$(scripts)"
	@echo "Uninstalled"
