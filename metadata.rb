# encoding: utf-8
# frozen_string_literal: true

name 'clamav'
maintainer 'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license 'Apache v2.0'
description 'Installs/configures ClamAV'
long_description 'Installs/configures ClamAV'
version '1.3.900'
chef_version '>= 12' if respond_to?(:chef_version)

source_url 'https://github.com/roboticcheese/clamav-chef'
issues_url 'https://github.com/roboticcheese/clamav-chef/issues'
depends           'logrotate'
depends           'yum'
depends           'yum-epel'
depends           'apt'
depends           'poise-service'
# Note that a breaking bug was introduced in 1.3.10 and fixed in 1.3.12, but
# we really don't want a ">=" cookbook dep situation here
depends           'cron'

supports 'ubuntu'
supports 'debian'
