require 'spec_helper'

describe 'xdmod' do
  let :facts do
    {
      :osfamily => 'RedHat',
    }
  end

  it { should create_class('xdmod') }
  it { should contain_class('xdmod::params') }

  it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::install]') }
  it { should contain_class('xdmod::install').that_comes_before('Class[xdmod::database]') }
  it { should contain_class('xdmod::database').that_comes_before('Class[xdmod::config]') }
  it { should contain_class('xdmod::config').that_comes_before('Anchor[xdmod::end]') }
  it { should contain_anchor('xdmod::end') }

  it_behaves_like 'xdmod::install'
  it_behaves_like 'xdmod::database'
  it_behaves_like 'xdmod::config'

  context 'when web => false' do
    let(:params) {{ :web => false }}

    it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::database]') }
    it { should contain_class('xdmod::database').that_comes_before('Anchor[xdmod::end]') }
    it { should contain_anchor('xdmod::end') }

    it { should_not contain_class('xdmod::install') }
    it { should_not contain_class('xdmod::config') }

    it_behaves_like 'xdmod::database'
  end

  context 'when database => false' do
    let(:params) {{ :database => false }}

    it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::install]') }
    it { should contain_class('xdmod::install').that_comes_before('Class[xdmod::config]') }
    it { should contain_class('xdmod::config').that_comes_before('Anchor[xdmod::end]') }
    it { should contain_anchor('xdmod::end') }

    it { should_not contain_class('xdmod::database') }

    it_behaves_like 'xdmod::install'
    it_behaves_like 'xdmod::config'
  end

  # Test validate_bool parameters
  [
    :database,
    :web,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('xdmod') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
