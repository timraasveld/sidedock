FROM odiobill/vsftpd
RUN bash -c 'useradd test -p $1$2f712aa7$bP1dXBeOEUoeTdnUeNLGQ/'

# Doesn't make sense in a real FTP server, but HTTP is used to test port mappings
EXPOSE 80
