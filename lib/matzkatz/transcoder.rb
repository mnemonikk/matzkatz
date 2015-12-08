module MatzKatz
  class Transcoder < Struct.new(:password)
    def decode(text)
      encoder.decrypt(Base64.decode64("U2FsdGVkX1" + text.gsub("|", "\n")))
    end

    def encode(text)
      Base64.encode64(encoder.encrypt(text)).gsub("\n", "|")[10..-1]
    end

    private

    def encoder
      @encoder ||= OpensslEnc.new(password)
    end
  end
end
