require "spec_helper"
require 'base64'

RSpec.describe MatzKatz::OpensslEnc do
  subject(:encoder) { described_class.new(password) }

  let(:ciphertext) { Base64.decode64("U2FsdGVkX19y40IR7ayx/2Fans9m6aFE") }
  let(:plaintext) { "text" }
  let(:password) { "key" }

  describe "#decrypt" do
    it "decrypts to known plaintext" do
      expect(encoder.decrypt(ciphertext)).to eq(plaintext)
    end

    it "throws an exception on invalid input" do
      expect { encoder.decrypt("a") }.to raise_exception(MatzKatz::OpensslEnc::InvalidCiphertext)
      expect { encoder.decrypt("a" * 16) }.to raise_exception(MatzKatz::OpensslEnc::InvalidCiphertext)
      expect { encoder.decrypt("a" * 17) }.to raise_exception(MatzKatz::OpensslEnc::InvalidCiphertext)
    end
  end

  describe "#encrypt" do
    it "creates ciphertext that can be decrypted again" do
      expect(encoder.decrypt(encoder.encrypt(plaintext))).to eq(plaintext)
    end

    it "creates a unique ciphertext" do
      expect(encoder.encrypt(plaintext)).to_not eq(ciphertext)
    end
  end
end
