module MatzKatz
  class DotGame
    def initialize(store, criterion)
      @store = store
      @criterion = criterion
    end

    def register(time, nick)
      if criterion.call(time)
        update(time, nick)
        yield if block_given?
      end
    end

    def scores
      store.transaction do
        store["scores"]
      end
    end

    private

    attr_reader :store, :criterion

    def update(time, nick)
      update_log(time, nick)
      update_score(nick)
    end

    def update_log(time, nick)
      store.transaction do
        store["log"] ||= []
        store["log"] << [time, nick]
      end
    end

    def update_score(nick)
      store.transaction do
        store["scores"] ||= {}
        store["scores"][nick] ||= 0
        store["scores"][nick] += 1
      end
    end
  end
end
