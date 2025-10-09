LATEXMK = latexmk

source_date_epoch = $(shell \
	git_time="$$(git log -1 --format=%at -- "$(1)")" && \
	test -n "$$git_time" && echo "$$git_time" || date -r "$(1)" +%s \
)
%.pdf: export SOURCE_DATE_EPOCH = $(call source_date_epoch,$<)

PDFS = article.pdf beamer.pdf

.PHONY: all
all: $(PDFS)

.PHONY: $(PDFS)
$(PDFS): %.pdf: %.tex
	$(LATEXMK) $(LATEXMK_FLAGS) -pdf $<

.PHONY: clean
clean:
	$(LATEXMK) $(LATEXMK_FLAGS) -c

.PHONY: distclean
distclean: clean
	$(RM) $(PDFS)
