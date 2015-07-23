require 'rails_helper' 
require 'search_term'
require 'exceptions'

describe SearchTerm do

  let(:item1) { double('one match (scored lower)', :column1 => "some text", :column2 => "example.com") }
  let(:item2) { double('one match (scored higher)', :column1 => "example.com", :column2 => "some text") }
  let(:item3) { double('two matches', :column1 => "example.com", :column2 => "example.com") }
  let(:item4) { double('zero matches', :column1 => "some text", :column2 => "some text") }
  let(:all_items) { [item1, item2, item3, item4] }
  let(:search_term) { SearchTerm.new(:scope => all_items, 
                                     :matching_scores => {:column1 => 3, :column2 => 1}) }

  it "searches items by term" do
    expect(search_term.search("example.com")).to eq [item3, item2, item1]
  end

  it "ignores letter case when searching" do
    expect(search_term.search("Example.Com")).to eq [item3, item2, item1]
  end

  it "returns only specified amount of results" do
    expect(search_term.search("example.com", 2)).to eq [item3, item2]
  end

  it "returns no results if characters limit is too strict" do
    search_term.characters_limit = 5
    expect(search_term.search("example.com")).to eq []
  end

  it "raises error when searching without necessary configuration" do
    expect { SearchTerm.new.search("example.com") }.to raise_error
  end

end
