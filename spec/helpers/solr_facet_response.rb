require 'yaml'

def solr_facet_response
  response = YAML.load_file(File.expand_path('../solr_facet_response.yaml', __FILE__))
  RSolr::Ext::Response::Base.new(response, nil, nil)
end
