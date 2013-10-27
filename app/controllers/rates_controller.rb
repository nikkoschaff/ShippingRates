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

	# #FEDEX
	# pass? Og9RdpcHV3S0NVeV
	# fedex = FedEx.new(:login => '118588852', :password => 'Og9RdpcHV3S0NVeV', key: 'UYBcUZO6CYbTmSObvl7Mtumsu', account: '510087160')
	# @fedexResponse = fedex.find_rates(@origin, @destination, @packages)

	# #USPS
	 usps = USPS.new(:login => '012MASSD7511')
	 @uspsResponse = usps.find_rates(@origin, @destination, @packages)

  end

private
  def post_params
    params.require(:rate).permit(:weight, :country, :state, :city, :zip)
  end

end
