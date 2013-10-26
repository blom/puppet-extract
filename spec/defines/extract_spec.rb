require "spec_helper"

describe "extract" do
  DEFAULT_PARAMS = {
    :file    => "/opt/example-1.2.3.tar.gz",
    :url     => "http://example.com/example-1.2.3.tar.gz",
    :target  => "/opt",
    :creates => "/opt/example-1.2.3",
  }

  DEFAULT_PARAMS.each { |key, val| let(key) { val } }
  let(:title) { "some description" }
  let(:params) { DEFAULT_PARAMS }
  let(:archive_file) { file }

  def params_with(key, val)
    DEFAULT_PARAMS.merge key => val
  end

  def params_without(*keys)
    DEFAULT_PARAMS.reject { |key, val| keys.include? key }
  end

  it { should contain_exec("download #{url} to #{archive_file}").
              with_command("curl -L #{url} -o #{archive_file}").
              with_onlyif(["test ! -e #{archive_file}",
                           "test ! -e #{creates}"]) }

  it { should contain_exec("extract #{archive_file}").
              with_command("tar xf #{archive_file} -C #{target}").
              with_require(/\AExec\[download #{url} to #{archive_file}\]/).
              with_creates(creates) }

  it { should_not contain_file(archive_file) }

  describe "file" do
    context "when present" do
      it { should contain_exec("download #{url} to #{file}") }
    end

    context "when not present" do
      let(:params) { params_without(:file) }
      it { should contain_exec("download #{url} to #{title}") }
    end
  end

  describe "when taropts is 'o'" do
    let(:params) { params_with(:taropts, 'o') }
    it { should contain_exec("extract #{archive_file}").
                with_command("tar xof #{archive_file} -C #{target}") }
  end

  describe "when 'purge' is true" do
    let(:params) { params_with(:purge, true) }
    it { should contain_file(archive_file).
                with_ensure("absent").
                with_require(/\AExec\[extract #{archive_file}\]/) }
  end

  describe "when 'url' is missing" do
    let(:params) { params_without(:url) }
    it { should_not contain_exec("download #{url} to #{title}") }
    it { should contain_exec("extract #{archive_file}").without_require }
  end

  describe "when 'target' is missing" do
    let(:params) { params_without(:target) }
    specify do
      expect {
        should contain_file(title)
      }.to raise_error(Puppet::Error, /Must pass target/)
    end
  end

  describe "when 'creates' is missing" do
    let(:params) { params_without(:creates) }
    specify do
      expect {
        should contain_file(title)
      }.to raise_error(Puppet::Error, /Must pass creates/)
    end
  end
end
