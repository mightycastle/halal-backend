module CollectionImagesHelper
  def get_image_url(collection_image)
    if collection_image && collection_image.image.present?
      collection_image.image.thumb("160x160#").url
    else
      asset_path "collection_image_default.png"
    end

  end
end
