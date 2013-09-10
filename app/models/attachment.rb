class Attachment < ActiveRecord::Base
  belongs_to :document
  validates_presence_of :file

  has_attached_file :file, :default_url => "/images/:style/missing.png"
end
