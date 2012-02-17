require "spec_helper"

describe "XMLGrammar" do
  it "DSL example..." do
    class HTMLForm < XMLGrammar
      element :form,  :action => REQ,
                              :method => "GET",
                              :enctype => "application/x-www-form-urlencoded",
                              :name => OPT
      element :input, :type => "text",
                              :name => OPT,
                              :value => OPT,
                              :maxlength => OPT,
                              :size => OPT,
                              :src => OPT,
                              :checked => BOOL,
                              :disabled => BOOL,
                              :readonly => BOOL
      element :textarea,  :rows => REQ,
                                   :cols => REQ,
                                   :name => OPT,
                                   :disabled => BOOL,
                                   :readonly => BOOL
      element :button,  :name => OPT,
                                 :value => OPT,
                                 :type => "submit",
                                 :disabled => OPT
    end
  end
end

