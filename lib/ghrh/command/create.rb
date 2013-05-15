module GHRH
  module Command
    class Create < Clamp::Command

      parameter 'NAME', 'Hook name' do |hook|
        raise "No such hook #{hook}" if not GHRH::Config.hooks[hook]
        hook
      end

      parameter 'CONFIG ...', 'Key=Value settings'
      option '--no-active', :flag, 'Do not activate', :default => false
      option ['-e', '--events'], 'EVENTS', 'Comma separated event names to trigger this hook for'
      option ['-r', '--repo'], 'REPO', 'Repo to create hook for', :default => GHRH::Config.get('github.repo')

      def execute
        raise "No repo specified (-r) or set (github.repo)" if not repo

        hook = GHRH::Config.hooks[name]

        # hook schema, build a hash for easy lookup name -> format
        schema = {}
        hook['schema'].each do |s|
          format, name = s
          schema[name] = format
        end

        default_events = hook['events']
        supported_events = hook['supported_events']

        # hook config that will be sent
        config = {}

        # make sure config settings given exist in the schema
        config_list.each do |arg|
          k,v = arg.split(/=/,2)
          raise "Invalid setting #{k} for hook #{name}" if not schema.include? k
          config[k]=v
        end

        # make sure events given are in supported events
        events_list = default_events
        if events
          events_list = events.split(/,/)
          events_list.each do |event|
            raise "Invalid event #{event} for hook #{name}" if not supported_events.include? event
          end
        end

        hook_input = {
          'name' => name,
          'events' => events_list,
          'config' => config,
          'active' => !no_active?,
        }.to_json

        resp = GHRH::Client.post("/repos/#{repo}/hooks", { :body => hook_input })

        puts "#{resp.code} #{resp.message}"
        pp "#{resp.body}" if $DEBUG
      end
    end
  end
end
