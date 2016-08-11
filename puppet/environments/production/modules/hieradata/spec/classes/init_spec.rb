require 'spec_helper'
describe 'hieradata' do

  context 'with defaults for all parameters' do
    it { should contain_class('hieradata') }
  end
end
