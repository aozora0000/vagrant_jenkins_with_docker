require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

# パッケージインストール確認
describe package('git') do
  it { should be_installed }
end

# パッケージインストール確認
describe package('htop') do
  it { should be_installed }
end
# パッケージインストール確認
describe package('which') do
  it { should be_installed }
end
# パッケージインストール確認
describe package('wget') do
  it { should be_installed }
end

# パッケージインストール確認
describe package('tar') do
  it { should be_installed }
end

# パッケージインストール確認
describe package('gcc') do
    it { should be_installed }
end

# パッケージインストール確認
describe package('openssl-devel') do
    it { should be_installed }
end

# パッケージインストール確認
describe package('libselinux-python') do
    it { should be_installed }
end
