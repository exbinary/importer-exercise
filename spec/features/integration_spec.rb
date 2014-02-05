require 'spec_helper'

describe 'The SaleImporter site', :integration, :truncate do
  include SpecHelpers

  # Note: these specs are not intended to be exhaustive.
  # They run through some common use cases that serve as integration specs.

  RSpec.configure do |c|
    c.alias_example_to :user
  end

  before { visit '/' }

  user 'is welcomed' do
    expect(page).to have_text('Welcome')
  end
  
  user 'looks at static pages' do
    expect {
      click_link 'About'
      click_link 'Home'
    }.not_to raise_error
  end

  describe 'authentication' do
    user 'tries to import a file without logging in' do
      click_link 'Upload a file for importing'
      expect(page).to have_text('You need to sign in')
    end

    user 'signs up' do
      sign_up
      expect(page).to have_text('signed up successfully')
    end
  end

  context 'with a signed up user' do
    before { sign_up }

    describe 'importing a file' do
      before { click_link 'Upload a file for importing' }

      user 'forgets to select a file' do
        click_button 'Import'
        expect(page).to have_selector('#flash_error')
        expect(page).to have_text("Please Choose a File to Import")
      end

      user 'successfully imports a file' do
        attach_file('import_file', sample_file_path)
        click_button 'Import'
        expect(page).to have_text('The file imported just fine')
        expect(page.first('table tr')).to have_text('$95')
      end
    end

  end

  def sign_up
    visit '/'
    click_link 'Log In'
    click_link 'Sign up', match: :first
    within("#new_user") do
      fill_in 'Email', :with => 'admin@example.com'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'password'
      click_button 'Sign up'
    end
  end
end
