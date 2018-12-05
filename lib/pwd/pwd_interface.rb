require 'httparty'
require 'net/ssh'
require 'ostruct'

class PwdInterface
    include HTTParty
  
    def initialize(uri)
        self.class.base_uri uri
        self.class.headers 'X-Requested-With' => 'XMLHttpRequest'
    end
  
    def create_session
      session = self.class.post('/')
      puts session.parsed_response
      session.parsed_response["session_id"]
    end
  
    def create_instance(session)
      res = self.class.post("/sessions/#{session}/instances")
      data = JSON.parse(res.parsed_response)
      OpenStruct.new(
          :ip => data["ip"],
          :proxy_host => data["proxy_host"],
          :id => data["name"]
      )
    end

    def get_instances(session)
        res = self.class.get("/sessions/#{session}")
        data = JSON.parse(res.parsed_response)
        instances = []
        res = data['instances']
        res.each do |k, v|
            instances << v
        end
        instances
    end

    def close_session(session)
        resp = self.class.delete("/sessions/#{session}")
        resp.code == 200
    end
end
