require File.join(File.dirname(__FILE__), 'spec_helper')
require File.join(File.dirname(__FILE__), '..', 'lib', 'nsidc_open_search', 'dataset', 'search', 'solr_search_suggest')

describe NsidcOpenSearch::Dataset::Search::SolrSearchSuggest do

  let(:base_search_parameters) do
    {
      queryType: 'suggestions'
    }
  end

  let(:solr_response) do
    double('entries', entries: ['sea ice', 'sea ice concentration', 'seasonally frozen ground']) # Make this look like solr_suggestion in the parser
  end

  let(:rsolr) { double('rsolr', get: solr_response) }
  let(:query_config) { YAML.load_file File.join(File.dirname(__FILE__), '..', 'config', 'solr_query_config_test.yml') }
  let(:solr_search) { described_class.new 'localhost:8983', NsidcOpenSearch::Dataset::Search::SolrSuggestionsParser, NsidcOpenSearch::Dataset::Model::Suggestions::SuggestionsResponseBuilder, query_config }

  before :each do
    RSolr.stub(:connect).and_return(rsolr)
  end

  describe 'suggestion request' do
    def get_should_receive_expectations(expected)
      rsolr.should_receive(:get) do |*args|
        expected.each do |k, v|
          args[0][k].should eql v
        end

        solr_response
      end
    end
  end
end
