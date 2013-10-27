class Rate < ActiveRecord::Base

	validates :weight, numericality: { :greater_than => 0 }
	validates_format_of :zip, :with => /^\d{5}(-\d{4})?$/, multiline: true, :message => "should be in the form 12345 or 12345-1234"
end
