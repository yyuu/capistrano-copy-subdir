require "capistrano/recipes/deploy/strategy/copy"
module Capistrano
  module Deploy
    module Strategy
      class CopySubdir < Copy
        VERSION = "0.0.2git"
      end
    end
  end
end
