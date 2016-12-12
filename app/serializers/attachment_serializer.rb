class AttachmentSerializer < ActiveModel::Serializer
  attributes :filename, :url
  
  def filename
    object.file.identifier
  end
  
  def url
    object.file.url
  end
end
