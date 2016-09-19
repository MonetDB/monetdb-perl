# configuration for "perl Makefile.PL"
# use e.g. "make CONFIG=PREFIX=$HOME"
CONFIG =

all: MonetDB-CLI-MapiPP/MonetDB/CLI/Makefile MonetDB-CLI/MonetDB/Makefile DBD/Makefile
	cd MonetDB-CLI-MapiPP/MonetDB/CLI; $(MAKE)
	cd MonetDB-CLI/MonetDB; $(MAKE)
	cd DBD; $(MAKE)

install: all
	cd MonetDB-CLI-MapiPP/MonetDB/CLI; $(MAKE) install DESTDIR=$(DESTDIR)
	cd MonetDB-CLI/MonetDB; $(MAKE) install DESTDIR=$(DESTDIR)
	cd DBD; $(MAKE) install DESTDIR=$(DESTDIR)

pure_install: all
	cd MonetDB-CLI-MapiPP/MonetDB/CLI; $(MAKE) pure_install DESTDIR=$(DESTDIR)
	cd MonetDB-CLI/MonetDB; $(MAKE) pure_install DESTDIR=$(DESTDIR)
	cd DBD; $(MAKE) pure_install DESTDIR=$(DESTDIR)

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
