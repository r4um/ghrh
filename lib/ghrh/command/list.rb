module GHRH
  module Command
    class List < Clamp::Command
      parameter "[REPO]", "repo", :default => GHRH::Config.get('github.repo')

      def execute
        raise "No repo specified or set (github.repo)" if not repo

        resp = GHRH::Client.get("/repos/#{repo}/hooks")

        raise "Unexpected response #{resp.code} #{resp.message}" if resp.code != 200

        tbl = Tabularize.new :vborder => '', :iborder => ''
        tbl << %w(id name active events)
        tbl.separator!
        resp.each do |p|
           tbl << [ p['id'], p['name'], p['active'], p['events'].join(',')
           ]
        end
        puts tbl
      end
    end
  end
end
