require 'active_shipping'
include ActiveMerchant::Shipping

class RatesController < ApplicationController
  def index
  end

  def new

  end

  def create
  	@rate = Rate.new(post_params)
 
  	@rate.save
  	redirect_to @rate
  end

  def show
  	@rate = Rate.find(params[:id])

  	@packages = [ Package.new( @rate.weight, [10,10,10], :units => :imperial ) ]

	@origin = Location.new(  :country => 'US',
                            :state => 'CA',
                            :city => 'Palo Alto',
                            :zip => '94306')

	@destination = Location.new( :country => @rate.country,
                            :state => @rate.state,
                            :city => @rate.city,
                            :zip => @rate.zip )

	#UPS
	ups = UPS.new(:login => 'massdroptest', :password => 'mansion92', :key => '8CC2BEE7ED40B8D5')
	@upsResponse = ups.find_rates(@origin, @destination, @packages)
	#ups_rates = upsResponse.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

	# #FEDEX
	# fedex = FedEx.new(:login => '999999999', :password => '7777777', key: '1BXXXXXXXXXxrcB', account: '51XXXXX20')
	# @fedexResponse = fedex.find_rates(@origin, @destination, @packages)
	# fexex_rates = fedexResponse.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

	# #USPS
	# usps = USPS.new(:login => 'developer-key')
	# @uspsResponse = usps.find_rates(@origin, @destination, @packages)
	# usps_rates = uspsResponse.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}


  end

private
  def post_params
    params.require(:rate).permit(:weight, :country, :state, :city, :zip)
  end

end
