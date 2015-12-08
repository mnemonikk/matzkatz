require "spec_helper"

RSpec.describe MatzKatz::FirstDotCriterion do
  subject(:criterion) { described_class.new }

  it "registers the first dot" do
    expect(criterion.call(Time.new(2010, 11, 22, 5, 33))).to be_truthy
    expect(criterion.call(Time.new(2010, 11, 22, 7, 0))).to be_falsy
    expect(criterion.call(Time.new(2010, 11, 23, 4, 59, 59))).to be_falsy
    expect(criterion.call(Time.new(2010, 11, 23, 5, 0))).to be_truthy
  end
end
