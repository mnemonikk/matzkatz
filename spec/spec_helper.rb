require_relative "../lib/matzkatz"

module MockStore
  def store
    @store ||=
      Hash.new.tap do |h|
        def h.transaction; yield; end
      end
  end
end

RSpec.configure do |config|
  config.include MockStore

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
