
DIR_BUILD := build

FILES_RAW_RECIPES := $(wildcard recipes/*.recipe)

FILES_BUILD_RECIPES := $(addprefix $(DIR_BUILD)/,$(notdir $(FILES_RAW_RECIPES)))
FILES_BUILD_MOBI := $(FILES_BUILD_RECIPES:.recipe=.mobi)

FILES_OPEN_MOBI := $(addprefix open/,$(notdir $(FILES_BUILD_MOBI)))

$(DIR_BUILD):
	mkdir $(DIR_BUILD)

$(FILES_BUILD_RECIPES): $(FILES_RAW_RECIPES) | $(DIR_BUILD)
	cp "$(addprefix recipes/,$(notdir $@))" "$(DIR_BUILD)"

$(FILES_BUILD_MOBI): $(FILES_BUILD_RECIPES) | $(DIR_BUILD)
	ebook-convert "$(@:.mobi=.recipe)" "$@" \
		--keep-ligatures \
		--smarten-punctuation \
		--enable-heuristics \
		--change-justification left \
		--output-profile kindle_pw \

.PHONY: $(FILES_OPEN_MOBI)
$(FILES_OPEN_MOBI): $(FILES_BUILD_MOBI)
	ebook-viewer $(FILES_BUILD_MOBI) \
		--raise-window \
		2>&1 > /dev/null \
		&

.PHONY: clean
clean:
	-rm -rf $(DIR_BUILD)

