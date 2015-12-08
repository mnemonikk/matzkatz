require "spec_helper"

RSpec.describe MatzKatz::DotGame do
  subject(:game) { described_class.new(store, criterion) }
  let(:criterion) { double("criterion", call: true) }
  let(:store) { Hash.new.tap do |h|
      def h.transaction; yield; end
    end
  }

  it "keeps scores" do
    game.register(Time.now, "leitmedium")
    game.register(Time.now, "leitmedium")
    game.register(Time.now, "mnemonikk")
    game.register(Time.now, "shrew")
    expect(game.scores).to include(
      "leitmedium" => 2,
      "mnemonikk" => 1,
      "shrew" => 1
      )
  end
end
