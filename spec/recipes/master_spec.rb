require 'spec_helper'

describe 'airgapped_jenkins::master' do
  context '(default) system account is false' do
    let(:home)          { '/opt/bacon' }
    let(:log_directory) { '/opt/bacon/log' }
    let(:user)          { 'bacon' }
    let(:group)         { 'meats' }

    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['airgapped_jenkins']['master']['home']           = home
        node.normal['airgapped_jenkins']['master']['log_directory']  = log_directory
        node.normal['airgapped_jenkins']['master']['user']           = user
        node.normal['airgapped_jenkins']['master']['group']          = group
      end.converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
    end

    it 'creates the user' do
      expect(chef_run).to create_user(user)
        .with_home(home)
    end

    it 'creates the group' do
      expect(chef_run).to create_group(group)
        .with_members([user])
    end

    it 'creates the home directory' do
      expect(chef_run).to create_directory(home)
        .with_owner(user)
        .with_group(group)
        .with_mode('0755')
        .with_recursive(true)
    end

    it 'creates the log directory' do
      expect(chef_run).to create_directory(log_directory)
        .with_owner(user)
        .with_group(group)
        .with_mode('0755')
        .with_recursive(true)
    end
  end

  context 'system account is true' do
    let(:home)          { '/opt/bacon' }
    let(:log_directory) { '/opt/bacon/log' }
    let(:user)          { 'bacon' }
    let(:group)         { 'meats' }

    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['airgapped_jenkins']['master']['home']           = home
        node.normal['airgapped_jenkins']['master']['log_directory']  = log_directory
        node.normal['airgapped_jenkins']['master']['user']           = user
        node.normal['airgapped_jenkins']['master']['group']          = group
        node.normal['airgapped_jenkins']['master']['use_system_accounts'] = true
      end.converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
    end

    it 'creates the user' do
      expect(chef_run).to create_user(user)
        .with_home(home)
        .with(system: true)
    end

    it 'creates the group' do
      expect(chef_run).to create_group(group)
        .with_members([user])
        .with(system: true)
    end

    it 'creates the home directory' do
      expect(chef_run).to create_directory(home)
        .with_owner(user)
        .with_group(group)
        .with_mode('0755')
        .with_recursive(true)
    end

    it 'creates the log directory' do
      expect(chef_run).to create_directory(log_directory)
        .with_owner(user)
        .with_group(group)
        .with_mode('0755')
        .with_recursive(true)
    end
  end
end
