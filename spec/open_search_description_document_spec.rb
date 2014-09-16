require File.join(File.dirname(__FILE__), 'spec_helper')
require File.join(File.dirname(__FILE__), '..', 'lib', 'open_search_dsl', 'open_search_description_document')

describe 'osdd dsl' do
  describe OpenSearchDsl::OpenSearchDescriptionDocument::Url::TemplateParameter do
    it 'cannont be created without name and replace val' do
      expect { OpenSearchDsl::OpenSearchDescriptionDocument::Url::TemplateParameter.new '', '' }.to raise_error(ArgumentError)
    end
  end

  describe OpenSearchDsl::OpenSearchDescriptionDocument::Url do
    it 'cannot be contructed without type,  base url, and parameters' do
      expect { OpenSearchDsl::OpenSearchDescriptionDocument::Url.new }.to raise_error(ArgumentError)
      expect { OpenSearchDsl::OpenSearchDescriptionDocument::Url.new { type 'atom' } }.to raise_error(ArgumentError)
      expect { OpenSearchDsl::OpenSearchDescriptionDocument::Url.new { base_url 'url' } }.to raise_error(ArgumentError)
      expect { OpenSearchDsl::OpenSearchDescriptionDocument::Url.new { parameter 'name', 'val' } }.to raise_error(ArgumentError)
    end

    it 'outputs a valid OSDD Url element' do
      parameters = {
        'st' => 'searchTerm',
        'bbox' => 'bbox?'
      }
      url = OpenSearchDsl::OpenSearchDescriptionDocument::Url.new do
        type 'atom'
        base_url 'http://test.org/dataset'
        parameters.each do |k, v|
          optional = v.end_with? '?'
          parameter k, (optional ? v.chop : v), !optional
        end
      end

      xml = url.to_xml

      xml.should have_a_type
      xml.should have_a_complete_template url.base_url, parameters
    end

    it 'preserves the https protocol' do
      url = OpenSearchDsl::OpenSearchDescriptionDocument::Url.new do
        type 'atom'
        base_url 'https://test.org/dataset'
        parameter 'st', 'searchTerm', true
      end

      xml = url.to_xml
      template = get_xml(xml).root.attribute('template')

      template.value.should eql 'https://test.org/dataset'
      have_a_complete_template url.base_url, 'st' => 'searchTerm'
    end
  end

  describe OpenSearchDsl::OpenSearchDescriptionDocument::Image do
    it 'cannot be constructed without url' do
      expect { OpenSearchDsl::OpenSearchDescriptionDocument::Image.new '' }.to raise_error(ArgumentError)
    end

    it 'outputs a valid OSDD Image element' do
      img = OpenSearchDsl::OpenSearchDescriptionDocument::Image.new 'http://test.org/image.jpg'
      xml = img.to_xml
      xml.should have_an_image_url
    end
  end

  describe OpenSearchDsl::OpenSearchDescriptionDocument::Query do
    it 'cannot be constructed without role' do
      expect { OpenSearchDsl::OpenSearchDescriptionDocument::Query.new '' }.to raise_error(ArgumentError)
    end

    it 'should allow multiple parameters' do
      q = OpenSearchDsl::OpenSearchDescriptionDocument::Query.new do
        parameter 'name', 'val'
        parameter 'name2', 'val2'
      end

      q.parameters.length.should be 2
    end

    it 'should output a valid OSDD Query element' do
      parameters = {
        'st' => 'searchTerm',
        'bbox' => 'bbox'
      }

      q = OpenSearchDsl::OpenSearchDescriptionDocument::Query.new do
        parameters.each do |k, v|
          parameter k, v
        end
      end

      xml = q.to_xml
      xml.should have_a_role
      xml.should have_parameters parameters
    end
  end

  describe OpenSearchDsl::OpenSearchDescriptionDocument do
    it 'cannot be constructed without short name, description and url' do
      expect { OpenSearchDsl::OpenSearchDescriptionDocument.new }.to raise_error(ArgumentError)
      expect { OpenSearchDsl::OpenSearchDescriptionDocument.new { short_name 'Short Name' } }.to raise_error(ArgumentError)
      expect { OpenSearchDsl::OpenSearchDescriptionDocument.new { description 'Description' } }.to raise_error(ArgumentError)
      expect { OpenSearchDsl::OpenSearchDescriptionDocument.new { url { type 'atom'; base_url 'url'; parameter 'name', 'val' } } }.to raise_error(ArgumentError)
    end

    it 'should allow multiple languages' do
      osdd = OpenSearchDsl::OpenSearchDescriptionDocument.new do
        short_name 'Short Name'
        description 'Description'
        url { type 'atom'; base_url 'url'; parameter 'name', 'val' }
        language 'en'
        language 'fr'
      end

      osdd.languages.length.should be 2
    end

    it 'should allow multiple input encodings' do
      osdd = OpenSearchDsl::OpenSearchDescriptionDocument.new do
        short_name 'Short Name'
        description 'Description'
        url { type 'atom'; base_url 'url'; parameter 'name', 'val' }
        input_encoding 'utf-8'
        input_encoding 'utf-16'
      end

      osdd.input_encodings.length.should be 2
    end

    it 'should allow multiple output encodings' do
      osdd = OpenSearchDsl::OpenSearchDescriptionDocument.new do
        short_name 'Short Name'
        description 'Description'
        url { type 'atom'; base_url 'url'; parameter 'name', 'val' }
        output_encoding 'utf-8'
        output_encoding 'utf-16'
      end

      osdd.output_encodings.length.should be 2
    end

    it 'outputs a valid OSDD' do
      osdd = OpenSearchDsl::OpenSearchDescriptionDocument.new do
        short_name 'Short Name'
        description 'Description'
        url { type 'atom'; base_url 'url'; parameter 'query', 'val' }
        url { type 'atom'; base_url 'url'; parameter 'facet', 'val' }
        url { type 'json'; base_url 'url'; parameter 'suggest', 'val' }
      end

      xml = osdd.to_xml

      xml.should have_opensearch_namespace
      xml.should have_opensearch_root_element
      xml.should have_a_short_name
      xml.should have_a_description
      xml.should have_at_least_three_urls
    end

    it 'outputs a valid OSDD with optional elements' do
      osdd = OpenSearchDsl::OpenSearchDescriptionDocument.new do
        namespace 'time', 'http://a9.com/-/opensearch/extensions/time/1.0/'
        short_name 'Short Name'
        description 'Description'
        url { type 'atom'; base_url 'url'; parameter 'name', 'val' }
        query { parameter 'st', 'searchTerm' }
        image 'http://test.org/image.jpg'
        long_name 'this is a test osdd'
        contact 'test@test.org'
        language 'en-us'
        input_encoding 'utf-8'
        output_encoding 'utf-8'
      end

      xml = osdd.to_xml

      xml.should have_namespace 'time', 'http://a9.com/-/opensearch/extensions/time/1.0/'
      xml.should have_a_contact
      xml.should have_at_least_one_query
      xml.should have_at_least_one_image
      xml.should have_at_least_one_language
      xml.should have_at_least_one_input_encoding
      xml.should have_at_least_one_output_encoding
    end
  end
end
