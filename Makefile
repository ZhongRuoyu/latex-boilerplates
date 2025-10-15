LATEXMK = latexmk

ifeq ($(findstring B,$(MAKEFLAGS)),B)
	LATEXMK_FLAGS += -g
endif

TARGETS = article beamer
PDFS = $(addsuffix .pdf,$(TARGETS))
DEPS = $(addsuffix .d,$(TARGETS))

.PHONY: all
all: $(PDFS)

source_date_epoch = $(shell \
	git_time="$$(git log -1 --format=%at -- "$(1)" 2>/dev/null)" && \
	test -n "$$git_time" && \
	echo "$$git_time" || \
	date -r "$(1)" +%s \
)
ALL_PDFS = $(sort $(PDFS) $(filter %.pdf,$(MAKECMDGOALS)))
$(ALL_PDFS): export SOURCE_DATE_EPOCH = $(call source_date_epoch,$(@:.pdf=.tex))
$(ALL_PDFS): %.pdf: %.tex
	$(LATEXMK) $(LATEXMK_FLAGS) -pdf -M -MP -MF $*.d $*

.PHONY: clean-deps
clean-deps:
	$(RM) $(DEPS)

.PHONY: clean
clean: clean-deps
	$(LATEXMK) $(LATEXMK_FLAGS) -c $(TARGETS)

.PHONY: distclean
distclean: clean
	$(LATEXMK) $(LATEXMK_FLAGS) -C $(TARGETS)

-include $(DEPS)
