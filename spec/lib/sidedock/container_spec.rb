describe Container do
  let(:image_name) { 'ftp_server' }
  let(:port_mapping) { {ftp: 80} }
  let(:container) { described_class.create image_name, port_mapping: port_mapping }

  before do
    allow_any_instance_of(DockerCLI).to receive(:create).and_return 'some_container_id'
    allow_any_instance_of(Ports).to receive(:define_port_accessors)
  end

  describe

  describe '#ports' do
    subject { container.ports }

    it 'defines the required ports' do
      expect(Ports).to receive(:new).with('some_container_id', port_mapping).and_call_original
      expect(subject).to be_a Ports
    end
  end
end
