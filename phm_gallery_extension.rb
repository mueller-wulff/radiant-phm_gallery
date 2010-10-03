# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class PhmGalleryExtension < Radiant::Extension
  version "0.1"
  description "Describe your extension here"
  url "http://over9000.org/rails/phm_gallery-a-gallery-generator-for-radiant"

  # See your config/routes.rb file in this extension to define custom routes
  Page.send :include, PhmGalleryTags 
end
