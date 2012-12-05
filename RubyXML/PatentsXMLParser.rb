require "rubygems"
require "bundler/setup"
require "nokogiri"

class PatentsXMLParser
  # Each of the patent files might include more than one patents represented in the XML format (well-formed or malformed).
  # This PATENT_REGX (non-greedy) can be used to extract the patent grants from the patent grant files that conform to
  # SGML2.4 and XML2.5 format. 
  # It is not necessary to use the group (.*?) here, but it might be convenient for the future.
  PATENT_REGX = Regexp.new(/<PATDOC.*?>(.*?)<\/PATDOC.*?>/imu)
  
  # process_bundle parses the patent file 
  def self.process_bundle(file)
    patent_regx = PatentsXMLParser::PATENT_REGX
 
    open(file) do |f| 
      # Load the contents of the patent file 
      # It might need some optimization here to prevent out-of-memory issues with super large patent files.
      str = f.read
      # Scan all the matched string fragments specified by the PATENT_REGX
      str.scan(PatentsXMLParser::PATENT_REGX) do |fragment|    
        # Yield the matched string
        yield $&
      end
    end
  end
 
  def initialize(str)
    @text = str
    # Parse the string as XML
    # @doc = Nokogiri::XML(@text)
    # Parse the string as HTML
    @doc = Nokogiri::HTML(@text)
  end
  
  def text
    @text
  end
  
  def doc_type
    :patent
  end
  
  def sourc_type
    :uspto_pat_xml
  end
  
  def patent_type
    
  end
  
  # B110 - number of document
  def pub_num
    node = @doc.xpath("//b110")
    node.to_html
  end
    
  # B130 - kind of document
  def pub_kind
    
  end
  
  # B140 - date of publication
  def pub_date
    
  end

  # B190 - publishing country or organization
  def pub_country_or_organization
    
  end
  
  # B220 - application filing date  
  def filing_date
    
  end
  
  def pub_classes
    
  end
  
  def title
    
  end
  
  def abstract
    
  end
  
  def inventors
    
  end

  def assignee
    
  end
  
  def app_num
    
  end
  
  def spec
    
  end
  
  def description
    
  end
  
  def claims
    
  end
end