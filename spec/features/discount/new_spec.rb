require 'rails_helper'

RSpec.describe 'Bulk Discount Create Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      @discount_1 = @merchant_1.discounts.create!(name: "5% off 20 or more items", min_item_quantity: 20, percent_off: 5)
    end

    it 'I can create a new discount' do
      visit "/merchant/discounts"

      click_link "New Discount"
      expect(current_path).to eq("/merchant/discounts/new")

      fill_in "Name", with: "10% off 25 or more items"
      fill_in "Min item quantity", with: 25
      fill_in "Percent off", with: 10
      click_on "Create Discount"

      new_discount = Discount.last

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("Discount Created")

      expect(page).to have_link(new_discount.name)
      expect(page).to have_content(new_discount.min_item_quantity)
      expect(page).to have_content(new_discount.percent_off)
    end
  end
end
