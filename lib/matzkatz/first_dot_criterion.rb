module MatzKatz
  class FirstDotCriterion
    EPOCH = Time.at(0)
    ONE_HOUR = 60 * 60

    def initialize(store)
      @store = store
    end

    def call(time)
      return false if time < next_dot
      store.transaction do
        store["last_dot"] = @last_dot = time
      end
      @next_dot = nil
      true
    end

    private

    attr_reader :store

    def last_dot
      @last_dot ||=
        begin
          store.transaction do
            store["last_dot"] ||= EPOCH
          end
        end
    end

    def next_dot
      @next_dot ||=
        begin
          date = last_dot.to_date
          date += 1 if last_dot.hour >= 5
          date.to_time + 5 * ONE_HOUR
        end
    end
  end
end
