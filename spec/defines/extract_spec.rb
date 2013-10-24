require "spec_helper"

describe "extract" do
  let(:title) { "some description" }

  let(:file)    { "/opt/example-1.2.3.tar.gz" }
  let(:url)     { "http://example.com/example-1.2.3.tar.gz" }
  let(:target)  { "/opt" }
  let(:creates) { "/opt/example-1.2.3" }

  let(:params) {{
    :file    => file,
    :url     => url,
    :target  => target,
    :creates => creates,
  }}

  let(:archive_file) { file }

  describe "file" do
    context "present" do
      it { should contain_exec("download #{url} to #{file}") }
    end

    context "not present" do
      let(:params) {{
        :url     => url,
        :target  => target,
        :creates => creates,
      }}

      it { should contain_exec("download #{url} to #{title}") }
    end
  end

  it { should contain_exec("download #{url} to #{archive_file}").
              with_command("curl -L #{url} -o #{archive_file}").
              with_onlyif(["test ! -e #{archive_file}", "test ! -e #{creates}"]) }

  it { should contain_exec("extract #{archive_file}").
              with_command("tar xf #{archive_file} -C #{target}").
              with_require(/\AExec\[download #{url} to #{archive_file}\]/).
              with_creates(creates) }

  it { should_not contain_file(archive_file) }

  describe "when taropts is 'o'" do
    let(:params) {{
      :file    => file,
      :target  => target,
      :creates => creates,
      :taropts => 'o',
    }}

    it { should contain_exec("extract #{archive_file}").
                with_command("tar xof #{archive_file} -C #{target}") }
  end

  describe "when 'purge' is true" do
    let(:params) {{
      :file    => file,
      :target  => target,
      :creates => creates,
      :purge   => true,
    }}

    it { should contain_file(archive_file).
                with_ensure("absent").
                with_require(/\AExec\[extract #{archive_file}\]/) }
  end

  describe "when 'url' is missing" do
    let(:params) {{
      :target  => target,
      :creates => creates,
    }}

    it { should_not contain_exec("download #{url} to #{title}") }
    it { should contain_exec("extract #{title}").without_require }
  end

  describe "when 'target' is missing" do
    let(:params) {{
      :creates => creates,
    }}

    specify do
      expect {
        should contain_file(title)
      }.to raise_error(Puppet::Error, /target must be present/)
    end
  end

  describe "when 'creates' is missing" do
    let(:params) {{
      :target => target,
    }}

    specify do
      expect {
        should contain_file(title)
      }.to raise_error(Puppet::Error, /creates must be present/)
    end
  end
end
