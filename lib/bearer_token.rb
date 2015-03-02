module BearerToken
  TOKEN_REGEX = /^Bearer /
  AUTHN_PAIR_DELIMITERS = /(?:,|;|\t+)/

  extend self

  def authenticate_with_http_token(controller, &login_procedure)
    authenticate(controller, &login_procedure)
  end

  def authenticate(controller, &login_procedure)
    token, options = token_and_options(controller.request)
    unless token.blank?
      login_procedure.call(token, options)
    end
  end

  def token_and_options(request)
    authorization_request = request.env['HTTP_X_AUTHORIZATION'].to_s
    if authorization_request[TOKEN_REGEX]
      params = token_params_from authorization_request
      [params.shift.last, Hash[params].with_indifferent_access]
    end
  end

  def token_params_from(auth)
    rewrite_param_values params_array_from raw_params auth
  end

  def params_array_from(raw_params)
    raw_params.map { |param| param.split %r/=(.+)?/ }
  end

  def rewrite_param_values(array_params)
    array_params.each { |param| param.last.gsub! %r/^"|"$/, '' }
  end

  def raw_params(auth)
    auth.sub(TOKEN_REGEX, '').split(/"\s*#{AUTHN_PAIR_DELIMITERS}\s*/)
  end
end
