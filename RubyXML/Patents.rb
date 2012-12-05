require './PatentsXMLParser'

files = [ "./grants/xml2/grants_2004_sample.xml" ]

files.each do |file|
  PatentsXMLParser.process_bundle(file) do |fragment|
    p = PatentsXMLParser.new(fragment) unless fragment.empty?
    p p.pub_num
  end
end

