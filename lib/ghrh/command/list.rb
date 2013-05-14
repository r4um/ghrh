module GHRH
  module Command
    class List < Clamp::Command
      parameter "[REPO]", "repo", :default => GHRH::Config.get('github.repo')

      def execute
        resp = GHRH::Client.get("/repos/#{repo}/hooks")
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
