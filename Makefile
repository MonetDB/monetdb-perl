# configuration for "perl Makefile.PL"
# use e.g. "make CONFIG=PREFIX=$HOME"
CONFIG =

all: MonetDB-CLI-MapiPP/MonetDB/CLI/Makefile MonetDB-CLI/MonetDB/Makefile DBD/Makefile
	$(MAKE) -C MonetDB-CLI-MapiPP/MonetDB/CLI
	$(MAKE) -C MonetDB-CLI/MonetDB
	$(MAKE) -C DBD

install: all
	$(MAKE) -C MonetDB-CLI-MapiPP/MonetDB/CLI install DESTDIR=$(DESTDIR)
	$(MAKE) -C MonetDB-CLI/MonetDB install DESTDIR=$(DESTDIR)
	$(MAKE) -C DBD install DESTDIR=$(DESTDIR)

pure_install: all
	$(MAKE) -C MonetDB-CLI-MapiPP/MonetDB/CLI pure_install DESTDIR=$(DESTDIR)
	$(MAKE) -C MonetDB-CLI/MonetDB pure_install DESTDIR=$(DESTDIR)
	$(MAKE) -C DBD pure_install DESTDIR=$(DESTDIR)

clean:
	cd MonetDB-CLI-MapiPP/MonetDB/CLI; rm -rf blib MYMETA.* pm_to_blib Makefile
	cd MonetDB-CLI/MonetDB; rm -rf blib MYMETA.* pm_to_blib Makefile
	cd DBD; rm -rf blib MYMETA.* pm_to_blib Makefile


MonetDB-CLI-MapiPP/MonetDB/CLI/Makefile: MonetDB-CLI-MapiPP/MonetDB/CLI/Makefile.PL
	cd MonetDB-CLI-MapiPP/MonetDB/CLI; perl Makefile.PL $(CONFIG)

MonetDB-CLI/MonetDB/Makefile: MonetDB-CLI/MonetDB/Makefile.PL
	cd MonetDB-CLI/MonetDB; perl Makefile.PL $(CONFIG)

DBD/Makefile: DBD/Makefile.PL
	cd DBD; perl Makefile.PL $(CONFIG)
