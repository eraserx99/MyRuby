require './PatentsXMLParser'

files = [ "./grants/xml24/grants_2001_sample.xml" ]

files.each do |file|
  PatentsXMLParser.process_bundle(file) do |fragment|
    p = PatentsXMLParser.new(fragment) unless fragment.empty?
    p p.pub_num
    p p.pub_kind
    p p.pub_date
    p p.pub_country_or_organization
    p p.filing_date
  end
end

