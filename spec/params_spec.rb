require_relative 'spec_helper'
require_relative '../lib/nsidc_open_search/dataset/search/factories/parameter_factory'

describe NsidcOpenSearch::Dataset::Search::ParameterFactory do
  before :each do
    @valids = [:q]
  end

  it 'should insert default query parameters' do
    search_params = NsidcOpenSearch::Dataset::Search::ParameterFactory.construct(
      {},
      @valids
    )
    expect(search_params).to eql({})
  end

  it 'should include valid query parameters' do
    search_params = NsidcOpenSearch::Dataset::Search::ParameterFactory.construct(
      { q: 'sea' },
      @valids
    )
    expect(search_params).to eql q: 'sea'
  end

  it 'should exclude empty query parameters' do
    search_params = NsidcOpenSearch::Dataset::Search::ParameterFactory.construct(
      { q: '' },
      @valids
    )
    expect(search_params).to eql({})
  end

  it 'should exclude invalid query parameters' do
    search_params = NsidcOpenSearch::Dataset::Search::ParameterFactory.construct(
      { q: 'sea', searchTerms: 'ice' },
      @valids
    )
    expect(search_params).to eql q: 'sea'
  end
end
