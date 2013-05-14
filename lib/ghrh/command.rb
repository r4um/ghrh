require 'ghrh/command/auth'
require 'ghrh/command/create'
require 'ghrh/command/delete'
require 'ghrh/command/edit'
require 'ghrh/command/get'
require 'ghrh/command/hooks'
require 'ghrh/command/list'
require 'ghrh/command/test'

module GHRH
  module Command
    class Main < Clamp::Command
      subcommand "auth", "get auth token from github", GHRH::Command::Auth
      subcommand "create", "create hook", GHRH::Command::Create
      subcommand "delete", "delete hook", GHRH::Command::Delete
      subcommand "edit", "edit hook", GHRH::Command::Edit
      subcommand "get", "get information for a hook", GHRH::Command::Get
      subcommand "hooks", "list known hooks and their parameters", GHRH::Command::Hooks
      subcommand "list", "list hooks", GHRH::Command::List
      subcommand "test", "test hook", GHRH::Command::Test
    end
  end
end

