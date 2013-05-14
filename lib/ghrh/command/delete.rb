module GHRH
  module Command
    class Delete < Clamp::Command
      parameter 'ID', 'Hook ID to get'
      option ['-r', '--repo'], 'REPO', 'The repo, ID belongs too', :default => GHRH::Config.get('github.repo')

      def execute
        raise "No repo specified (-r) or set (github.repo)" if not repo
        resp = GHRH::Client.delete("/repos/#{repo}/hooks/#{id}")
        puts "#{resp.code} #{resp.message}"
        puts resp.body
        puts "Deleted" if resp.code == 204
      end
    end
  end
end
