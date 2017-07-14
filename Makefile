REBAR   = rebar3
PROJECT = toy
VERSION = 0.1.0

all: compile

compile:
	@$(REBAR) compile

clean:
	@$(REBAR) clean
	rm -f $(PROJECT).tar.gz

dialyzer:
	@$(REBAR) dialyzer

rel release: compile
	@$(REBAR) release

test:
	$(REBAR) ct

update:
	@$(REBAR) update

console:
	  ./_build/default/rel/$(PROJECT)/bin/$(PROJECT) console \
	  -pa ${PWD}/_build/default/lib/toy/ebin

.PHONY: compile rel clean dialyzer check tarball console test travis-test update staging-compile staging-tarball
