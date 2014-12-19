require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

# パッケージインストール確認
describe package('nginx') do
  it { should be_installed }
end

# 起動確認
describe service('nginx') do
    it { should be_running }
end

# 起動確認
describe service('httpd') do
    it { should_not be_running }
end

# ポート確認
describe port(80) do
  it { should be_listening }
end
