module GHRH
  module Command
    class Hooks < Clamp::Command
      parameter "[HOOK]", "Show parameters for HOOK"
      option "--refresh", :flag, "Refresh hooks cache"

      def execute
        GHRH::Config.fetch_hooks if refresh?

        hooks = GHRH::Config.hooks

        if hook
          pp hooks[hook]
        else
          puts hooks.keys.sort
        end
      end
    end
  end
end
