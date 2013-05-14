module GHRH
  module Command
    class Get < Clamp::Command
      parameter 'ID', 'Hook ID to get'
      option ['-r', '--repo'], 'REPO', 'The repo, ID belongs too', :default => GHRH::Config.get('github.repo')

      def execute
        raise "No repo specified (-r) or set (github.repo)" if not repo
        resp = GHRH::Client.get("/repos/#{repo}/hooks/#{id}")
        puts "#{resp.code} #{resp.message}"
        pp resp
      end
    end
  end
end
