require 'rails_helper'

describe WordFormatter, type: :model do
  it "correctly formats scraped data" do
    job_words = ["Hello, purple purple cake cake cake."]
    expect(WordFormatter.format_api_results(job_words)).to eq([["cake", 3], ["purple", 2], ["hello", 1]])
  end

  it "handles garbage input" do
    garbage = ["Hello,./// \][ ohnoablackhole... !"]
    expect(WordFormatter.format_api_results(garbage)).to eq([["ohnoablackhole", 1], ["hello", 1]])
  end

  it "ignores words on the omitted list" do
    largely_omitted = ["Tetris tetris. And and and or or of in a such!"]
    expect(WordFormatter.format_api_results(largely_omitted)).to eq([["tetris", 2]])
  end
end
