require "spec_helper"

describe "extract" do
  let(:title) { "/opt/example-1.2.3.tar.gz" }

  let(:url)     { "http://example.com/example-1.2.3.tar.gz" }
  let(:target)  { "/opt" }
  let(:creates) { "/opt/example-1.2.3" }

  let(:params) {{
    :url     => url,
    :target  => target,
    :creates => creates,
  }}

  it { should contain_exec("download #{url} to #{title}").
              with_command("curl -L #{url} -o #{title}").
              with_onlyif(["test ! -e #{title}", "test ! -e #{creates}"]) }

  it { should contain_exec("extract #{title}").
              with_command("tar xf #{title} -C #{target}").
              with_require(/\AExec\[download #{url} to #{title}\]/).
              with_creates(creates) }

  it { should_not contain_file(title) }

  describe "when taropts is 'o'" do
    let(:params) {{
      :target  => target,
      :creates => creates,
      :taropts => 'o',
    }}

    it { should contain_exec("extract #{title}").
                with_command("tar xof #{title} -C #{target}") }
  end

  describe "when 'purge' is true" do
    let(:params) {{
      :target  => target,
      :creates => creates,
      :purge   => true,
    }}

    it { should contain_file(title).
                with_ensure("absent").
                with_require(/\AExec\[extract #{title}\]/) }
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
