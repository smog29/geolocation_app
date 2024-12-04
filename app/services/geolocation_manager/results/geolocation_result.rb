module GeolocationManager
  module Results
    class GeolocationResult
      attr_reader :success, :data, :errors

      def initialize(success:, data: nil, errors: nil)
        @success = success
        @data = data
        @errors = errors
      end

      def success?
        @success
      end
    end
  end
end
