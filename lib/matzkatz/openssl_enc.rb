require "openssl"

module MatzKatz
  class OpensslEnc < Struct.new(:password)
    InvalidCiphertext = Class.new(RuntimeError)

    class KeyDerivation
      def initialize(password, salt = nil)
        @password = password
        @salt = salt
      end

      def key
        @key ||=
          OpenSSL::Digest::MD5.digest(password + salt)
      end

      def iv
        @iv ||=
          OpenSSL::Digest::MD5.digest(key + password + salt)[0, 8]
      end

      def salt
        @salt ||= OpenSSL::Random.random_bytes(8)
      end

      private

      attr_reader :password
    end

    def decrypt(ciphertext)
      raise InvalidCiphertext if ciphertext.size < 17
      key_derivation = KeyDerivation.new(password, ciphertext[8, 8])
      cipher = _cipher
      cipher.decrypt
      cipher.iv = key_derivation.iv
      cipher.key = key_derivation.key
      cipher.update(ciphertext[16..-1]) + cipher.final
    rescue OpenSSL::Cipher::CipherError
      raise InvalidCiphertext
    end

    def encrypt(plaintext)
      key_derivation = KeyDerivation.new(password)
      cipher = _cipher
      cipher.encrypt
      cipher.iv = key_derivation.iv
      cipher.key = key_derivation.key
      "Salted__" + key_derivation.salt +
        cipher.update(plaintext) + cipher.final
    end

    private

    def _cipher
      OpenSSL::Cipher::BF.new
    end
  end
end
