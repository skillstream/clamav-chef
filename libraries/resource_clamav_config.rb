# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: clamav
# Library:: resource_clamav_config
#
# Copyright 2012-2016, Jonathan Hartman
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
#

require 'chef/resource'
require_relative 'helpers_defaults'

class Chef
  class Resource
    # A Chef resource for ClamAV config files.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ClamavConfig < Resource
      include ClamavCookbook::Helpers::Defaults

      provides :clamav_config

      default_action :create

      #
      # The service must be one of the recognized services: 'clamd' or
      # 'freshclam'.
      #
      property :service_name,
               String,
               name_property: true,
               equal_to: %w(clamd freshclam)

      #
      # Allow the user to override the path of the config dir (at their peril).
      #
      property :path, String, default: lazy { clamav_conf_dir }

      #
      # A hash of config values.
      #
      property :config, [Hash, nil], default: nil

      #
      # Build a config file out of the provided hash and write it out to the
      # proper path.
      #
      action :create do
        directory new_resource.path do
          owner clamav_user
          group clamav_group
          recursive true
        end
        file ::File.join(new_resource.path,
                         "#{new_resource.service_name}.conf") do
          owner clamav_user
          group clamav_group
          content ClamavCookbook::Helpers::Config.new(
            send("#{new_resource.service_name}_config")
              .merge(new_resource.config.to_h)
          ).to_s
        end
      end

      #
      # Delete the config file.
      #
      action :delete do
        file ::File.join(new_resource.path,
                         "#{new_resource.service_name}.conf") do
          action :delete
        end
        directory new_resource.path do
          action :delete
        end
      end
    end
  end
end
