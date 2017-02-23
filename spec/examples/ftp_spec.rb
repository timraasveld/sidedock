require_relative '../sidedock/ftp_server/ftp_server'
require 'net/ftp'

describe Net::FTP do
  it 'can download a file' do
    FtpServer.use do |ftp_server|
      ftp_server.add_file 'some_file.txt', 'some content'

      ftp_client = Net::FTP.new
      
      ftp_client.connect ftp_server.ip, ftp_server.ports.ftp
      ftp_client.login 'test', 'test'

      expect(ftp_client.list).to include 'some_file.txt'
    end
  end
end