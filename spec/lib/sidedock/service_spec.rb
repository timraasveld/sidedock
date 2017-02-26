require_relative '../../docker/ftp_server'

describe Service do
  let(:klass) { FtpServer }

  describe '.use' do
    it 'creates a container during the execution of the block' do
      original_number_of_running_containers = Container.all.size

      klass.use do |service|
        expect(Container.all.size).to eq original_number_of_running_containers + 1
      end

      expect(Container.all.size).to eq original_number_of_running_containers
    end

    context 'with no Dockerfile in services\' directory' do
      it 'raises' do
        allow(File).to receive(:exist?).and_return false
        expect { klass.use }.to raise_error DockerfileNotFound
      end
    end
  end

  describe '.cli_method' do
    it 'creates a wrapper for system calls' do
      klass.instance_eval do
        cli_method :echo
      end

      klass.use do |service|
        expect(service).to respond_to :echo
        expect(service.echo 'some echoed text').to eq 'some echoed text'
      end
    end

    context 'class already responded to one of the methods' do
      subject do
        klass.instance_eval do
          cli_method :to_s
        end
      end

      it 'raises' do
        expect { subject }.to raise_error MethodInUse
      end
    end
  end

  describe '.port' do
    it 'creates a port accessor for the automatic IP given by Docker' do
      klass.instance_eval do
        port :http, 80
      end

      klass.use do |service|
        expect(service.ports).to respond_to :http
        expect(service.ports.http).to be_an Integer
      end
    end
  end
end
