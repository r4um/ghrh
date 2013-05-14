module GHRH
  module Config

    def self.scope
      File.exists?(File.join(Dir.pwd,'.git/config')) == true ? "local" : "global"
    end

    def self.get(setting, default=nil)
      # Check environment first, if setting is x.y env is X_Y
      value = ENV[setting.upcase.gsub('.', '_')] || ""

      # Check local git config
      value = %x{git config --local #{setting} 2>/dev/null}.strip if value.empty?

      # Check global git config
      value = %x{git config --global #{setting} 2>/dev/null}.strip if value.empty?

      # Return default if all above failed to return anything
      value = default if value.empty?

      value
    end

    def self.token
      get('ghrh.token')
    end

    DEFAULT_HOST = 'api.github.com'
    HOST = get("github.host", DEFAULT_HOST)
    USER_AGENT = "ghrh/#{GHRH::VERSION}"
    API_URL = HOST == DEFAULT_HOST ? "https://#{HOST}" : "https://#{HOST}/api/v3"

    CACHE_DIR = File.expand_path '~/.ghrh'
    CACHE_FILE = File.join CACHE_DIR, "hooks_#{HOST}.json"

    def self.set(setting, value, config_scope=scope)
      # Set config setting, if user specified scope use that, else detect
      %x{git config --#{config_scope} #{setting} #{value}}
    end

    def self.fetch_hooks
      resp = GHRH::Client.get("/hooks", :headers => {"User-Agent" => USER_AGENT})
      hooks_h = {}
      resp.each do |hook|
        hooks_h[hook['name']]=hook
      end
      File.open(CACHE_FILE, 'w').write(hooks_h.to_json)
      puts "Wrote hooks cache to #{CACHE_FILE}"
    end

    def self.hooks
      if not File.directory? CACHE_DIR
        Dir.mkdir CACHE_DIR
      end

      if not File.exists? CACHE_FILE
        puts "No hooks cache found fetching"
        fetch_hooks
      end
      JSON.load File.read CACHE_FILE
    end
  end
end
