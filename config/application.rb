require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 5.2

    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local
    # i18n
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end

# RSpecの設定
module Taskleaf
  class Application < Rails::Application
    config.load_defaults 6.0

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: true,
                       system_specs: true
    end
  end
end
