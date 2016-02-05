include stack.mk

all: test

IVORY_EX_TEST_DIR=test-dir-c-files

PACKAGE= \
  ivory \
  ivory-artifact \
  ivory-backend-acl2 \
  ivory-backend-c \
  ivory-eval \
  ivory-examples \
  ivory-hw \
  ivory-model-check \
  ivory-opts \
  ivory-quickcheck \
  ivory-serialize \
  ivory-stdlib

PACKAGEDIR=$(foreach p, $(PACKAGE), $(p)/)


.PHONY: test
test: default
	stack exec -- ivory-c-clang-test $(IVORY_EX_TEST_DIR)
	cd $(IVORY_EX_TEST_DIR) && gcc -Wall -Wextra -I. -std=c99 -c *.c *.h -Wno-missing-field-initializers -Wno-unused-parameter -Wno-unused-variable -DIVORY_DEPLOY

	stack test ivory-model-check
	stack test ivory-eval
	stack test ivory-quickcheck

.PHONY: veryclean
veryclean:
	stack clean
	-rm -rf $(IVORY_EX_TEST_DIR)

# Travis-ci specfic ############################################################

installplan.txt:
	cabal install --only-dep --enable-tests --enable-benchmarks --dry -v \
		$(PACKAGE:%=%/) > $@

travis-install-dep:
	cabal install --only-dep --enable-tests --enable-benchmarks $(PACKAGE:%=%/)

travis-install:
	cabal install $(PACKAGE:%=%/)

travis-test = (cd $1 \
	&& cabal configure --enable-tests \
	&& cabal test)

travis-test:
	$(HOME)/.cabal/bin/ivory-c-clang-test $(IVORY_EX_TEST_DIR)
	cd $(IVORY_EX_TEST_DIR) && gcc -Wall -Wextra -I. -std=c99 -c *.c *.h -Wno-missing-field-initializers -Wno-unused-parameter -Wno-unused-variable -DIVORY_DEPLOY

# The following are cabal "test" targets
	$(call travis-test,ivory-model-check)
	$(call travis-test,ivory-eval)
	$(call travis-test,ivory-quickcheck)
