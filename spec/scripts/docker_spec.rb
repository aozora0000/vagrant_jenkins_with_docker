require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

# パッケージインストール確認
describe package('docker-io') do
    it { should be_installed }
end
