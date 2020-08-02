require 'rails_helper'

RSpec.describe 'Bulk Discount Edit Page' do
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

    it 'I can edit the information of a discount' do
      visit "/merchant/discounts/#{@discount_1.id}"

      click_link "Update Discount"
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")


      expect(find("#discount_name").value).to eq(@discount_1.name)
      expect(find("#discount_min_item_quantity").value.to_i).to eq(@discount_1.min_item_quantity)
      expect(find("#discount_percent_off").value.to_i).to eq(@discount_1.percent_off)

      fill_in "Name", with: "A new name"

      click_on "Update Discount"
      expect(page).to have_content("Discount Updated")
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}")
      expect(page).to have_content("A new name")
    end
  end
end
