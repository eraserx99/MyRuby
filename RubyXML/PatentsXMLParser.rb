require "rubygems"
require "bundler/setup"
require "nokogiri"

class PatentsXMLParser
  # Each of the patent files might include more than one patents represented in the XML format (well-formed or malformed).
  # This PATENT_REGX (non-greedy) can be used to extract the patent grants from the patent grant files that conform to
  # SGML2.4 and XML2.5 format. 
  # It is not necessary to use the group (.*?) here, but it might be convenient for the future.
  PATENT_REGX = Regexp.new(/<PATDOC.*?>(.*?)<\/PATDOC.*?>/imu)
  
  # The PATENT_KIND_REGX is used to exclude the patents we are not interested.
  # Based on the explanation of RECOMMENDATED STANDARD CODE FOR THE IDENTIFICATION OF
  # DIFFERENT KINDS OF PATENT DOCUMENTS STANDARD ST. 16.
  # The KIND code is presented in the format ONE LETTER CODE and ONE DIGIT CODE.
  # The ONE LETTER CODE is subdivided into mutually exclusive groups of letters. The groups of characterize patent documents. 
  # TODO: further review needed
  PATENT_KIND_REGX = Regexp.new(/[ABCUYZ]\d/imu)
  
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
  
  # Extract the inner text of the element
  # It returns an empty string if the element is nil
  def extract_inner_text(element)
    element != nil ? element.inner_text : ""
  end
  private :extract_inner_text
  
  def doc_type
    :patent
  end
  
  def sourc_type
    :uspto_pat_xml
  end
  
  # TODO: further review needed
  def patent_type
    kind = pub_kind
    kind =~ PatentsXMLParser::PATENT_KIND_REGX ? :utility : :other
  end
  
  # The member functions below help to extract information from the patent
  # If the patent is constructed as Nokogiri::HTML object, all the element names are lower-cased.
  # If the patent is constructed as Nokogiri::XML object, all the element names are kept as the original inputs.
  
  # B110 - number of document
  def pub_num
    node = @doc.at_xpath("//b110")
    extract_inner_text(node)
  end
    
  # B130 - kind of document
  def pub_kind
    node = @doc.at_xpath("//b130")
    extract_inner_text(node)
  end
  
  # B140 - date of publication
  def pub_date
    node = @doc.at_xpath("//b140")
    extract_inner_text(node)
  end

  # B190 - publishing country or organization
  def pub_country_or_organization
    node = @doc.at_xpath("//b190")
    extract_inner_text(node)
  end
  
  # B220 - application filing date  
  def filing_date
    node = @doc.at_xpath("//b220")
    extract_inner_text(node)
  end
  
  # B511 - main classification
  # B512 - further classification
  def pub_classes
    classes = []
    # Collect the main classification
    node = @doc.at_xpath("//b511")
    classes << extract_inner_text(node) unless node == nil
    # Collect the further classification, if any
    node = @doc.at_xpath("//b512")
    classes << extract_inner_text(node) unless node == nil
    classes
  end
  
  # B540 - title
  def title
    node = @doc.at_xpath("//b540")
    extract_inner_text(node)
  end
  
  # B210 - application number
  def app_num
    node = @doc.at_xpath("//b210")
    extract_inner_text(node) 
  end
  
  # B220 - application filing date
  def app_filing_date
    node = @doc.at_xpath("//b220")
    extract_inner_text(node)     
  end
  
  # B720 - inventor information
  # B721 - name & address
  # This function returns the inventor information as an array of hashes.
  # [ [ 'first_name' => '...', 'last_name' => '...', ]]
  def inventors
    ivs = []
    
    if b720 = @doc.at_xpath("//b720") 
      b721 = b720.xpath(".//b721")
      # Iterate through the elements
      b721.each do |inventor|
        iv = Hash.new
        
        # Look for elements (such as fnm, snm, etc) relative to the current element (inventor)
        first_name = inventor.at_xpath(".//fnm")
        last_name = inventor.at_xpath(".//snm")
        organization = inventor.at_xpath("..//onm")
        city = inventor.at_xpath(".//city")
        country = inventor.at_xpath(".//ctry")
        iv.store(:first_name, extract_inner_text(first_name)) unless first_name == nil
        iv.store(:last_name, extract_inner_text(last_name)) unless last_name == nil
        iv.store(:organization, extract_inner_text(organization)) unless organization == nil
        iv.store(:city, extract_inner_text(city)) unless city == nil
        iv.store(:country, extract_inner_text(country)) unless country == nil
        ivs << iv
      end
    end
    
    ivs
  end

  # B730 - assignee information
  # B731 - name & address
  # This function returns the assignee information as an array of hashes.
  # [ [last name1; first name1], [last name2; first name 2], ...]
  def assignee
    assigs = []
    
    if b730 = @doc.at_xpath("//b730") 
      b731 = b730.xpath(".//b731")
      # Iterate through the elements
      b731.each do |assignee|
        assig = Hash.new
        
        # Look for elements (such as fnm, snm, etc) relative to the current element (assignee)
        first_name = assignee.at_xpath(".//fnm")
        last_name = assignee.at_xpath(".//snm")
        organization = assignee.at_xpath("..//onm")
        city = assignee.at_xpath(".//city")
        country = assignee.at_xpath(".//ctry")
        assig.store(:first_name, extract_inner_text(first_name)) unless first_name == nil
        assig.store(:last_name, extract_inner_text(last_name)) unless last_name == nil
        assig.store(:organization, extract_inner_text(organization)) unless organization == nil
        assig.store(:city, extract_inner_text(city)) unless city == nil
        assig.store(:country, extract_inner_text(country)) unless country == nil
        assigs << assig
      end
    end
    
    assigs
  end

 # SDOAB - abstract
  def abstract
    node = @doc.at_xpath("//sdoab")
    extract_inner_text(node)         
  end
  
  # SDOCL - claims
  def claims
    node = @doc.at_xpath("//sdocl")
    extract_inner_text(node)          
  end  
    
  # SDOD - description  
  def description
    node = @doc.at_xpath("//sdod")
    extract_inner_text(node)      
  end
  
  # Specification is equal to description concatenated with claims
  def spec
    description + "\n" + claims
  end

end