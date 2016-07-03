describe ':compile' do
  it 'installs docker' do
    expect(subject.execute).to be_truthy
  end
end
