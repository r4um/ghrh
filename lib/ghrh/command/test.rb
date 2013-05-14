module GHRH
  module Command
    class Test < Clamp::Command
      parameter 'ID', 'Hook ID to post test'
      option ['-r', '--repo'], 'REPO', 'The repo, ID belongs too', :default => GHRH::Config.get('github.repo')

      def execute
        raise "No repo specified (-r) or set (github.repo)" if not repo

        resp = GHRH::Client.post("/repos/#{repo}/hooks/#{id}/tests")
        puts "#{resp.code} #{resp.message}"
        pp resp
      end
    end
  end
end
