module HeaderHelper
   def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.projectdiscussion.v#{version}"
    end

    def api_response_format(format = Mime::JSON)
      request.headers['Accept'] = "#{request.headers['Accept']},#{format}"
      request.headers['Content-Type'] = format.to_s
    end

    def ios_application
      @ios_application ||= create(:application) 
    end
 
    def api_application_token
      request.headers['HTTP_AUTHORIZATION'] = "Token token=#{ios_application.token}"
    end

    def include_default_accept_headers
      api_header
      api_response_format
      api_application_token
    end
end