require 'ruby-nfc'

class Rfid
  def read_uid
    NFC::Reader.all[0].poll(IsoDep::Tag, Mifare::Classic::Tag, Mifare::Ultralight::Tag) do |tag|
      return tag.uid.unpack('H*')[0].upcase
    end
  end
end

if __FILE__ == $0
  rf = Rfid.new
  uid = rf.read_uid
  puts uid
end
