class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  
  mount_uploader :file, FileUploader
  
  validates :file, presence: true
end
