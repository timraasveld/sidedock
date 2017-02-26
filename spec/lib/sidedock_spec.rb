describe Sidedock do
  context 'Project uses Rails (Rails::Railtie defined)' do
    before do
      stub_const 'Rails', Module.new
      stub_const 'Rails::Railtie', Class.new
      load 'sidedock.rb'
    end

    it 'loads the railtie' do
      expect(Sidedock.const_defined?(:Railtie)).to be true
    end
  end

  context 'Project doesn\'t use Rails (Rails::Railtie undefined)' do
    before do
      stub_const 'Rails', nil

      # Ensure railtie is not loaded from previous example
      Sidedock.send :remove_const, :Railtie if defined? Sidedock::Railtie

      load 'sidedock.rb'
    end

    it 'does not load the railtie' do
      expect(Sidedock.const_defined?(:Railtie)).to be false
    end
  end
end
