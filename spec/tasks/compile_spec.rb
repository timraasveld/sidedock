require 'spec_helper'

describe 'ensure_docker_installed' do
  context 'Docker is installed' do
    it 'raises no error' do
      allow(Kernel).to receive(:system).and_return true
      subject.invoke
    end
  end

  context 'Docker is not installed' do
    it 'raises error' do
      allow(Kernel).to receive(:system).and_return false
      expect { subject.invoke }.to raise_error DockerCommandMissingError
    end
  end
end
