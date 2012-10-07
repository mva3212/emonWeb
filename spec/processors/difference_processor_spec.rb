describe DifferenceProcessor do
  it 'should tell data should be stored' do
    DifferenceProcessor.store?.should == true
  end

  it 'should tell its description' do
    DifferenceProcessor.description.should == 'Only store the value is different than last one'
  end


  describe 'perfom' do
    before(:each) do
      @feed = Feed.create!(:last_value => 252.55, :name => 'electra', :input_id => 3, :user_id => 1)
    end

    it 'should only store the value is different than last one' do   
      DataStore.expects(:create).with(:value => 123.45, :identified_by => @feed.id)
      Feed.expects(:update).with(@feed.id, :last_value => 123.45)
      processor = DifferenceProcessor.new(123.45, @feed.id)
      processor.perform.should == 123.45
    end

    it 'should not store the value it is the same as the last one' do   
      DataStore.expects(:create).never
      Feed.expects(:update).never
      processor = DifferenceProcessor.new(252.55, @feed.id)
      processor.perform.should == 252.55
    end

  end
end