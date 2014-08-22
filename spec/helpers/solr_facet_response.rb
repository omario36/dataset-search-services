def solr_facet_response
  response = {
    'responseHeader' => {
      'status' => 0,
      'QTime' => 19,
      'params' =>  {
        'f.facet_spatial_coverage.facet.mincount' => '1',
        'facet' => %w(true, true),
        'facet.limit' => '-1',
        'qf' => 'title^15 parameters^3 summary^5 topics keywords^3 platforms^2 sensors^2 normalized_authoritative_id^100 authors',
        'f.facet_temporal_duration.facet.sort' => 'index',
        'f.facet_spatial_coverage.facet.sort' => 'index',
        'wt' => 'ruby',
        'defType' => 'edismax',
        'rows' => '0',
        'pf' => 'title^25 parameters^5 summary^25 keywords^5',
        'bq' => 'brokered:false^100 published_date:[NOW-2YEARS/DAY TO NOW/DAY]^15',
        'facet.sort' => 'count',
        'start' => '0',
        'q' => 'snow',
        'f.facet_temporal_duration.facet.mincount' => '1',
        'boost' => 'product(popularity,query( { !type=edismax qf=$qf pf=$pf ps=$ps bq=$bq bf=sum(1,product(tan(div(popularity,8)),50))^55 v=$q boost= } ) )',
        'facet.field' => %w(facet_temporal_duration, facet_spatial_coverage), 'fq' => 'source:NSIDC', 'ps' => '1'
      }
    },
    'response' => { 'numFound' => 388, 'start' => 0, 'docs' => [] },
    'facet_counts' =>  {
      'facet_queries' => {},
      'facet_fields' => {
        'facet_temporal_duration' => ['1 - 4 years', 99, '10+ years', 122, '5 - 9 years', 43, '< 1 year', 93, 'Not specified', 41],
        'facet_spatial_coverage' => ['Global', 35, 'Non Global', 329],
        'facet_sensor' => ['Special Sensor Microwave Imager/Sounder | SSMIS', 25,
                           'Special Sensor Microwave/Imager', 50,
                           'Imaging Radar Systems, Real and Synthetic Aperture | IMAGING RADAR SYSTEMS', 100,
                           'Radio Detection and Ranging | RADAR', 75,
                           ' | no long name', 75]
      },
      'facet_dates' => {},
      'facet_ranges' => {}
    }
  }
  RSolr::Ext::Response::Base.new(response, nil, nil)
end
