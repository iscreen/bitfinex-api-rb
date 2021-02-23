module Bitfinex
  module RESTv2Platform
    ###
    # Get the current status of the platform, “Operative” or “Maintenance”.
    # Maintenance periods generally last for a few minutes to a couple of
    # hours and may be necessary from time to time during infrastructure upgrades.
    #
    # @param [Hash|Array|Position|number] position - must contain or be ID
    #
    # @return [Array] Raw notification
    ###
    def platform_status
      get("platform/status").body
    end
  end
end
