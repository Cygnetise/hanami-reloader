# frozen_string_literal: true

require "hanami/cyg_cli/commands"
require "hanami/cyg_utils"

module Hanami
  module CygUtils # rubocop:disable Style/Documentation
    # Monkey-patch `Hanami::Utils.reload!` to disable Ruby based code-reloading
    def self.reload!(directory)
      require!(directory)
      warn "Requiring #{directory}"
    end
  end

  # Hanami::Reloader
  module Reloader
    require "hanami/reloader/version"
    require "hanami/reloader/cli"
  end
end
