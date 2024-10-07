require 'ruby-nfc'

class Rfid
  def read_uid
    NFC::Reader.all[0].poll(Mifare::Classic::Tag) do |tag|         
        uid=''
        8.times do |i|
                if(tag.uid_hex[i]==nil)
                        uid+='0'
                else
                        uid+=tag.uid_hex[i]
                end
        end
        return uid.upcase
     end
  end
end

if __FILE__ == $0
  rf = Rfid.new
  uid = rf.read_uid                                              
  puts uid
end
