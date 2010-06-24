class ExvoAuth::Routes
  class << self
    def path_with_query(path, params = {})
      query = Rack::Utils.build_query(params)
      query.empty? ? path : "#{path}?#{query}"
    end

    def interactive_sign_in_path(params = {})
      path_with_query("/auth/interactive", params)
    end

    def non_interactive_sign_in_path(params = {})
      path_with_query("/auth/non_interactive", params)
    end
  end
end