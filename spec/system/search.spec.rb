require 'rails_helper'

describe '検索機能', type: :system, js: true do
  let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@email.com') }
  let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@email.com') }
  let!(:recipe_a) { create(:recipe, user: user_a, name: 'Aのレシピ１') }
  let!(:recipe_b) { create(:recipe, user: user_b, name: 'Bのレシピ１') }

  before do
    visit root_path
  end

  context 'レシピの検索結果にて' do
    before do
      fill_in 'q[name_cont]', with: 'A'
      click_on '検索'
    end

    it 'Aの含まれるレシピが表示される' do
      expect(page).to have_content 'A'
    end

    it 'Aの含まれないレシピは表示されない' do
      expect(page).not_to have_content recipe_b.name
    end
  end
end