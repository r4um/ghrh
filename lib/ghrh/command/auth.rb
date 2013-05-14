module GHRH
  module Command
    class Auth < Clamp::Command
      parameter '[USER]', 'GitHub User name', :default => GHRH::Config.get('github.user')
      option '--local', :flag, 'Update local git config', :default => false

      def execute
        user = GHRH::Config.get('github.user') if not user

        raise "No GitHub user given or set" if not user

        pass = ask("Enter password for user #{user} (never stored): ") do |q|
          q.echo = ''
        end

        token = GHRH::Auth.perform(user, pass)

        if token
          scope = local? == true ? "local" : "global"
          GHRH::Config.set("ghrh.token", token, scope)
          puts "ghrh.token set to #{token} in #{scope} git config"
        else
          puts "Authentication failed, invalid user or password"
        end
      end
    end
  end
end
