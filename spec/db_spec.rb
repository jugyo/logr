$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'db'
require 'tmpdir'
require 'fileutils'

describe 'db' do
  before do
    @tmpdir = Dir.tmpdir + '/logr_test'
    FileUtils.rm_rf(@tmpdir)
    FileUtils.mkdir_p(@tmpdir)
    KVS.dir = @tmpdir

    @now = Time.now
    Time.stub!(:now).and_return(@now)
  end

  describe 'create entry' do
    before do
      create_entries
    end

    it 'should create entry' do
      key = Entry << {:title => 'title title', :body => 'body body'}
      entry = Entry[key]
      entry.should == {:title => 'title title', :body => 'body body', :updated_at => @now, :created_at => @now}
    end
  end

  describe 'update entry' do
    before do
      create_entries
      @key = Entry << {:title => 'title title', :body => 'body body'}
    end

    it 'should update entry' do
      entry = Entry[@key]
      entry.should == {:title => 'title title', :body => 'body body', :updated_at => @now, :created_at => @now}

      fake_updated_at = Time.local(2009, 9, 16)
      Time.should_receive(:now).and_return(fake_updated_at)

      Entry[@key] = entry.merge({:title => 'TITLE!!', :body => 'BODY!!'})
      updated_entry = Entry[@key]
      updated_entry.should == {:title => 'TITLE!!', :body => 'BODY!!', :updated_at => fake_updated_at, :created_at => @now}
    end
  end

  describe 'delete entry' do
    before do
      create_entries
      @key = Entry << {:title => 'title title', :body => 'body body'}
    end

    it 'should delete entry' do
      Entry.delete(@key)
      Entry[@key].should be_nil
      keys = Entry.keys
      keys.include?(@key).should be_false
    end
  end

  describe 'keys' do
    describe 'no entry' do
      it 'no key' do
        Entry.keys.should == []
      end
    end

    describe 'many entries' do
      before do
        create_entries
      end

      it 'many keys' do
        Entry.keys.size.should == 10
        Entry[Entry.keys.first][:title].should == 'title_0'
        Entry[Entry.keys.last][:title].should == 'title_9'
      end

      describe 'create entry' do
        before do
          @key = Entry << {:title => 'title title', :body => 'body body'}
        end

        it 'keys include new entry\'s key' do
          Entry.keys.include?(@key).should be_true
        end
      end

      describe 'delete entry' do
        before do
          @key = Entry.keys.first
          Entry.delete(@key)
        end

        it 'keys include new entry\'s key' do
          Entry.keys.include?(@key).should be_false
        end
      end
    end
  end

  def create_entries
    10.times do |i|
      Entry << {:title => "title_#{i}", :body => "body_#{i}"}
    end
  end
end
