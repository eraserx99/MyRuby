require "spec_helper"

describe XML do
  it "Taste it!" do
    pagetitle = "Test Page for XML.generate"
    xml = ""
    XML.generate(xml) do
      html do 
        head do
          title { pagetitle }
          comment "This is a test"
        end
        body do
          h1(:style => "font-family:sans-serif") { pagetitle }
          ul :type=>"square" do
            li { Time.now }
            li { RUBY_VERSION }
          end
        end
      end
    end
    xml.should match(/^<html.*\/html>$/)
  end
end
