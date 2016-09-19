Name:		perl-DBD-monetdb
Version:	1.0
Release:	1%{?dist}
Summary:	MonetDB perl interface

License:	MPLv2.0
URL:		http://www.monetdb.org/
Source0:	https://dev.monetdb.org/hg/monetdb-perl/archive/v%{version}.tar.bz2

BuildArch:	noarch
BuildRequires:	perl
BuildRequires:	perl-generators
# Correct for lots of packages, other common choices include eg. Module::Build
BuildRequires:	perl(ExtUtils::MakeMaker)
Requires:  perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

Obsoletes:	MonetDB-client-perl
Recommends:	MonetDB-SQL-server5

%{?perl_default_filter}

%description
MonetDB is a database management system that is developed from a
main-memory perspective with use of a fully decomposed storage model,
automatic index management, extensibility of data types and search
accelerators.  It also has an SQL frontend.

This package contains the files needed to use MonetDB from a Perl
program.

%prep
%autosetup -n monetdb-perl-v%{version}


%build
%make_build CONFIG=INSTALLDIRS=vendor

%install
rm -rf $RPM_BUILD_ROOT
make pure_install DESTDIR=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} ';'
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null ';'
%{_fixperms} $RPM_BUILD_ROOT/*


%files
%license license.txt
#%doc add-docs-here
%{perl_vendorlib}/*
%{_mandir}/man3/*.3*


%changelog
* Mon Sep 19 2016 Sjoerd Mullender <sjoerd@mullender.nl>
- The Perl interface to MonetDB is now a separate package.
