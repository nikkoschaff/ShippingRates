class Rate < ActiveRecord::Base

	validates :weight, numericality: { :greater_than => 0 }
	validates_format_of :zip, :with => /^\d{5}(-\d{4})?$/, multiline: true, :message => "should be in the form 12345 or 12345-1234"

	validate :zip_code_must_match_state

	def zip_code_must_match_state
		unless self.state == ZipCodeInfo.instance.state_for( self.zip )
			 errors.add(:zip, "is not valid for the state specified")
		end
	end

end
