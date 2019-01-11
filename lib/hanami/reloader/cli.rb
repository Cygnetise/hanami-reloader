# frozen_string_literal: true

module Hanami
  module Reloader
    module CLI
      # Generate hanami-reloader configuration
      class Generate < Hanami::CLI::Commands::Command
        requires "environment"

        desc "Generate configuration for code reloading"

        def call(*)
          path = Hanami.root.join(".hanami.server.guardfile")

          files.touch(path)
          files.append path, <<~CODE
            url = ENV.fetch('CONTROL_URL')
            token = ENV.fetch('CONTROL_TOKEN')
            command = "curl #{host}/restart?token=#{token}"
            guard 'process', :name => 'reloader', :command => command do
              watch(%r{config/*})
              watch(%r{lib/*})
              watch(%r{apps/*})
            end
CODE
        end
      end

      # Override `hanami server` command
      class Server < Hanami::CLI::Commands::Command
        desc "Starts the puma server with control token and url (only development)"
        option :control_token, default: "foobar", desc: "The control token you would like puma to start with"
        option :control_url, default: "tcp://localhost:9293", desc: "The control url you would like puma to start with"

        def call(**options)
          exec "bundle exec puma --config config/puma.rb --control-token #{options.fetch(:control_token)} --control-url #{options.fetch(:control_url)} --environment development"
        end
      end

      class Reloader < Hanami::CLI::Commands::Command
        desc "Starts code reloading (only development) reloader"
        option :control_token, default: "foobar", desc: "The control token you would like puma to start with"
        option :control_url, default: "http://localhost:9293", desc: "The control url you would like puma to start with"

        def call(**options)
          exec "CONTROL_TOKEN=#{options.fetch(:control_token)} CONTROL_URL=#{options.fetch(:control_url)} bundle exec guard -n f -i -G .hanami.server.guardfile"
        end
      end
    end
  end
end

Hanami::CLI.register "generate reloader", Hanami::Reloader::CLI::Generate
Hanami::CLI.register "server",            Hanami::Reloader::CLI::Server
Hanami::CLI.register "reloader",          Hanami::Reloader::CLI::Reloader
