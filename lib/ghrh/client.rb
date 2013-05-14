module GHRH
  class Client
    include HTTParty

    base_uri GHRH::Config::API_URL

    headers "User-Agent" => GHRH::Config::USER_AGENT

    headers "Authorization" => "token #{GHRH::Config.token}"

    format :json
    debug_output if $DEBUG
  end
end
