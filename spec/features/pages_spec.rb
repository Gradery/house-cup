require "rails_helper"

feature 'Index page without ' do
	before :all do
		@s = FactoryGirl.create(:school)
	end

	describe "the index page", :type => :feature do
		scenario "has link to the school" do
			visit '/'
			expect(page).to have_link @s.name
		end

		scenario "has link to the support email" do
			visit '/'
			expect(page).to have_link "Support"
		end

		scenario "does not have link to the about page" do
			visit '/'
			expect(page).to_not have_link "About"
		end

		scenario "link goes to right school" do
			visit '/'
			click_link(@s.name)
			expect(page).to have_content "Cup"
		end
	end

	describe "the show page", :type => :feature do
		scenario "has the right content" do
			visit '/'+@s.url
			expect(page).to have_content "Cup"
		end

		scenario "has a link to the about page" do
			visit '/'+@s.url
			expect(page).to have_link "About"
		end

		scenario "has a link to the login page" do
			visit '/'+@s.url
			expect(page).to have_link "Login"
		end

		scenario "does not have a link to the score page" do
			visit '/'+@s.url
			expect(page).to_not have_link "Score"
		end

		scenario "does not have a link to the My Profile page" do
			visit '/'+@s.url
			expect(page).to_not have_link "My Profile"
		end
	end

	describe "the sign in page", :type => :feature do
		scenario "user can log in" do
			visit "/staffs/sign_in"
			expect(page).to have_content "Log in"
		end

		scenario "has sign up link" do
			visit "/staffs/sign_in"
			expect(page).to have_link "Sign up"
		end

		scenario "sign up link goes to right place" do
			visit "/staffs/sign_in"
			click_link "Sign up"
			expect(page).to have_content "Password confirmation"
		end

		scenario "has forgot password link" do
			visit "/staffs/sign_in"
			expect(page).to have_link "Forgot your password?"
		end

		scenario "forgot password link goes to right place" do
			visit "/staffs/sign_in"
			click_link "Forgot your password?"
			expect(page).to have_button "Send me reset password instructions"
		end

		scenario "user signs in" do
			u = FactoryGirl.build(:staff, :school_id => @s.id)
			u.password = "password"
			u.password_confirmation = "password"
			u.save!
			visit "/staffs/sign_in"
			within("#new_staff") do
		      fill_in 'Email', :with => u.email
		      fill_in 'Password', :with => 'password'
		    end
		    click_button 'Log in'
    		expect(page).to have_content 'My Profile'
		end
	end

	describe "forgot password page", :type => :feature do
		scenario "user enters email" do
			u = FactoryGirl.create(:staff)
			visit "/staffs/password/new"
			within("#new_staff") do
		      fill_in 'Email', :with => u.email
		    end
		    click_button 'Send me reset password instructions'
		    expect(page).to have_content "You will receive an email with instructions on how to reset your password in a few minutes."
		end
	end
end