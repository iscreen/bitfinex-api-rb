module Bitfinex
  module RESTv2Funding

    ###
    # Active Funding Offers
    #
    # @param [string] symbol - used for the query funding offers
    #
    # @return [Array] Raw notification
    ###
    def active_funding_offers(symbol)
      authenticated_post("auth/r/funding/offers/#{symbol}").body
    end

    ###
    # Submit a new funding offer
    #
    # @param [Hash|FundingOffer] offer
    #
    # @return [Array] Raw notification
    ###
    def submit_funding_offer(offer)
      if offer.instance_of?(Models::FundingOffer)
        packet = offer.to_new_order_packet
      elsif offer.kind_of?(Hash)
        packet = Models::FundingOffer.new(offer).to_new_order_packet
      else
        raise Exception, 'tried to submit offer of unkown type'
      end
      authenticated_post("auth/w/funding/offer/submit", params: packet).body
    end

    ###
    # Cancel an active funding offer
    #
    # @param [Hash|Array|FundingOffer|number] offer - must contain or be ID
    #
    # @return [Array] Raw notification
    ###
    def cancel_funding_offer(offer)
      if offer.is_a?(Numeric)
        id = offer
      elsif offer.is_a?(Array)
        id = offer[0]
      elsif offer.instance_of?(Models::FundingOffer)
        id = offer.id
      elsif offer.kind_of?(Hash)
        id = offer[:id] || order['id']
      else
        raise Exception, 'tried to cancel offer with invalid ID'
      end
      authenticated_post("auth/w/funding/offer/cancel", params: { :id => id }).body
    end

    ###
    # Close a funding loan/credit
    #
    # @param [Hash|Array|FundingOffer|FundingLoan|FundingCredit|number] funding - must contain or be ID
    #
    # @return [Array] Raw notification
    ###
    def close_funding(funding)
      if funding.is_a?(Numeric)
        id = funding
      elsif funding.is_a?(Array)
        id = funding[0]
      elsif funding.instance_of?(Models::FundingOffer)
        id = funding.id
      elsif funding.instance_of?(Models::FundingLoan)
        id = funding.id
      elsif funding.instance_of?(Models::FundingCredit)
        id = funding.id
      elsif funding.kind_of?(Hash)
        id = funding[:id] || order['id']
      else
        raise Exception, 'tried to close funding with invalid ID'
      end
      authenticated_post("auth/w/funding/close", params: { :id => id }).body
    end

    ###
    # Submit a new auto funding request
    #
    # @param [string] currency - urrency for which to enable auto-renew
    # @param [number] amount - amount to be auto-renewed (Minimum 50 USD equivalent)
    # @param [string] rate - percentage rate at which to auto-renew. (rate == 0 to renew at FRR)
    # @param [integer] period - period in days
    # @param [integer] status - 1 for activate and 0 for deactivate
    #
    # @return [Array] Raw notification
    ###
    def submit_funding_auto(currency, amount, period, rate='0', status=1)
      dec_amount = BigDecimal(amount, 8).to_s
      payload = { :status => status, :currency => currency, :amount => dec_amount, :period => period, :rate => rate }
      authenticated_post("auth/w/funding/auto", params: payload).body
    end

    ###
    # Keep Funding
    # @param [string] type - Specify the funding type ('credit' or 'loan')
    # @param [string] id - an array of id's to toggle their keep funding status
    # @param [string] changes - object to specify changes for each id
    #
    # @return [Array] Raw notification
    ###
    def keep_funding(type, id, changes = {})
      raise Exception, 'keep funding with invalid TYPE' unless ['credit', 'loan'].include?(type)
      if id.is_a?(Numeric)
        ids = [id]
      elsif id.is_a?(Array)
        ids = id
      end
      payload = { :type => type, :id => id, :changes => changes }
      authenticated_post("auth/w/funding/keep", params: payload).body
    end

    ###
    # Cancel All Funding Offers
    #
    # @param [string] symbol - Specifying a currency is optional.
    #                          If the currency param is omitted, all open offers will be cancelled.
    #
    # @return [Array] Raw notification
    # @example:
    #   client.cancel_all_funding_offers('USD')
    ###
    def cancel_all_funding_offers(symbol = nil)
      payload = if symbol
                  { :currency => symbol }
                else
                  {}
                end
      authenticated_post("auth/w/funding/offer/cancel/all", params: payload).body
    end

    ###
    # Funds not used in active positions
    #
    # @param [string] symbol - used for the query funding offers
    #
    # @return [Array] Raw notification
    ###
    def funding_loans(symbol = nil)
      authenticated_post("auth/r/funding/loans/#{symbol}").body
    end

    ###
    # Get account funding info
    #
    # @param [string] symbol - used for the query funding offers
    #
    # @return [Array] Raw notification
    ###
    def funding_info(symbol = nil)
      authenticated_post("auth/r/info/funding/#{symbol}").body
    end
  end
end
