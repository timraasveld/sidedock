class FtpServer < Sidedock::Service
  cli_method :cat # Add convenience methods for commonly used commands
  port :ftp, 21 # exposes external FTP port as service.ports.ftp

  def add_file(filename, content)
    sh "echo '#{content}' > #{filename}"
  end
end
