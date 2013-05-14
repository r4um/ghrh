module GHRH
  class Cli < Clamp::Command
    subcommand "list", "list repo hooks", GHRH::Command::List
  end
end
