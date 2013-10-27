require 'active_shipping'
include ActiveMerchant::Shipping

class RatesController < ApplicationController
  def index
  end

  def new
  	@rate = Rate.new
  end

  def create
  	@rate = Rate.new(post_params)
 

 	if 	@rate.save
  		redirect_to @rate
  	else
  		render "new"
  	end
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
	# fedex = FedEx.new(:login => 'massdroptest', :password => 'Mansion92', key: 'Va9bTNUMedCe9FdNVbtnBFwck', account: '510087160', meter: '118588852')
	# pass UYBcUZO6CYbTmSObvl7Mtumsu / Va9bTNUMedCe9FdNVbtnBFwck / Og9RdpcHV3S0NVeV
	# account 510087160
	# meter 118588852
	# @fedexResponse = fedex.find_rates(@origin, @destination, @packages)
	# fexex_rates = fedexResponse.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

	# #USPS
	 usps = USPS.new(:login => '012MASSD7511')
	 @uspsResponse = usps.find_rates(@origin, @destination, @packages)
	 usps_rates = @uspsResponse.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}


  end

private
  def post_params
    params.require(:rate).permit(:weight, :country, :state, :city, :zip)
  end

end
