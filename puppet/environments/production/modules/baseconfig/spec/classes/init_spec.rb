require 'spec_helper'
describe 'baseconfig' do

  context 'with defaults for all parameters' do
    it { should contain_class('baseconfig') }
  end
end
