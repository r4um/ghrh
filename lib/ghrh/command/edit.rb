module GHRH
  module Command
    class Edit < Clamp::Command

      parameter 'ID', 'Hook ID to edit'
      parameter '[CONFIG] ...', 'Key=Value settings'
      option '--no-active', :flag, 'Do not activate', :default => false
      option ['-e', '--events'], 'EVENTS', 'Comma separated event names to trigger this hook for'
      option ['-r', '--repo'], 'REPO', 'Repo to create hook for', :default => GHRH::Config.get('github.repo')

      def execute
        raise "No repo specified (-r) or set (github.repo)" if not repo

        hooks = GHRH::Config.hooks

        res = GHRH::Client.get("/repos/#{repo}/hooks/#{id}")

        raise "Invalid hook ID #{id}" if not res['name']

        name = res['name']
        hook = hooks[name]

        # hook schema, build a hash for easy lookup name -> format
        schema = {}
        hook['schema'].each do |s|
          format, name = s
          schema[name] = format
        end

        supported_events = hook['supported_events']

        # hook config that will be sent
        config = {}

        # make sure config settings given exist in the schema
        config_list.each do |arg|
          k,v = arg.split(/=/,2)
          raise "Invalid setting #{k} for hook #{id} (#{name})" if not schema.include? k
          config[k]=v
        end

        # make sure events given are in supported events
        events_list = []
        if events
          events_list = events.split(/,/)
          events_list.each do |event|
            raise "Invalid event #{event} for hook #{id} (#{name})" if not supported_events.include? event
          end
        end

        hook_input = {}
        hook_input['events'] = events_list if not events_list.empty?
        hook_input['config'] = config if not config.empty?
        hook_input['active'] = !no_active?

        resp = GHRH::Client.patch("/repos/#{repo}/hooks/#{id}", { :body => hook_input.to_json })

        puts "#{resp.code} #{resp.message}"
        pp "#{resp.body}" if $DEBUG
      end
    end
  end
end
