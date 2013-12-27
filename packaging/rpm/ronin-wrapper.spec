# Author:: Nathan Milford (<nathan@milford.io>)
# Copyright:: Copyright (c) 2013 Nathan Milford
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

%define gemname      ronin-wrapper
%define ruby_sitelib %(ruby -rrbconfig -e "puts Config::CONFIG['sitelibdir']")
%define gemdir       %(ruby -rubygems -e 'puts Gem::dir' 2>/dev/null)
%define gemversion   %(ruby -e "require './lib/ronin/version'; puts Ronin::VERSION")
%define geminstdir   %{gemdir}/gems/%{gemname}-%{gemversion}
%define gemfile      %{gemname}-%{gemversion}.gem
%define gemspec      %{gemname}.gemspec
%define reporoot     %(pwd)
%define confdir      %{_sysconfdir}/ronin/
%define logdir       /var/log/ronin/
%define moduledir    /var/lib/ronin/

Name:          %{gemname}
Version:       %{gemversion}
Release:       1
Summary:       A framework for masterless Puppet.
License:       ASF 2.0
URL:           https://github.shuttercorp.net/nmilford/ronin
Group:         System Environment/Base
Buildroot:     %{_tmppath}/%{name}-%{version}-%{release}-%(%{__id_u} -n)
Packager:      Nathan Milford <nmilford@shutterstock.com>
Source0:       http://rubygems.org/gems/%{gemfile}
Requires:      rubygems
#Requires:      rubygem(yajl-ruby)
#Requires:      rubygem(mixlib-log)
#Requires:      rubygem(mixlib-config)
#Requires:      rubygem(mixlib-shellout)
BuildRequires: rubygems
BuildArch:     noarch

%description
A framework for masterless Puppet.

%prep

%build

cd %{reporoot}
gem build %{gemspec}

%clean
rm -rf %{buildroot}
rm -rf %{reporoot}/%{gemfile}

%install
rm -rf %{buildroot}

install -d -m 755 %{buildroot}/%{gemdir}
install -d -m 755 %{buildroot}/%{_bindir}

gem install --local --install-dir %{buildroot}%{gemdir} --force --rdoc %{reporoot}/%{gemfile}

mv %{buildroot}%{gemdir}/bin/ronin %{buildroot}/%{_bindir}

install -d -m 755 %{buildroot}/%{confdir}
install -d -m 755 %{buildroot}/%{logdir}
install -d -m 755 %{buildroot}/%{moduledir}

install    -m 644 %{reporoot}/config/modules.yaml.sample %{buildroot}/%{confdir}/modules.yaml.sample
install    -m 644 %{reporoot}/config/ronin.rb.sample     %{buildroot}/%{confdir}/ronin.rb.sample

%files
%defattr(-, root, root, -)
%{_bindir}/ronin
%{gemdir}/gems/%{gemname}-%{version}/
%doc %{gemdir}/doc/%{gemname}-%{version}
%{gemdir}/cache/%{gemname}-%{version}.gem
%{gemdir}/specifications/%{gemname}-%{version}.gemspec
%{confdir}/*
%dir %{logdir}
%dir %{moduledir}

%changelog
* Fri Dec 27 2012 Nathan Milford <nmilford@shutterstock.com>
- Initial package