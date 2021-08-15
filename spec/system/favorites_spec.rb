require 'rails_helper'

describe 'お気に入り機能', type: :system do
  let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@email.com') }
  let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@email.com') }
  let!(:recipe_a) { create(:recipe, user: user_a, name: 'Aのレシピ１') }
  let!(:recipe_b) { create(:recipe, user: user_b, name: 'Bのレシピ１') }

  describe 'レシピページにて' do
    context '非ログイン時' do
      it 'レシピページにはお気に入り登録ボタンが表示されない' do
        visit recipe_path(recipe_a)
        expect(page).not_to have_link '#favorite_btn'
      end
    end

    context 'ログイン時' do
      before do
        visit login_path
        fill_in 'メールアドレス', with: user_a.email
        fill_in 'パスワード', with: user_a.password
        click_button 'ログイン'
      end

      it 'ユーザーのレシピページではお気に入り登録ボタンが表示されない' do
        visit recipe_path(recipe_a)
        expect(page).not_to have_link '#favorite_btn'
      end

      it '別ユーザーのレシピページではお気に入り登録/解除ができる' do
        visit recipe_path(recipe_b)
        click_link 'お気に入り登録'
        expect(user_a.favorite_recipes.ids).to include recipe_b.id
        click_link 'お気に入り解除'
        expect(user_a.favorite_recipes.ids).not_to include recipe_b.id
      end

      it 'お気に入り登録したレシピが一覧に表示される' do
        visit recipe_path(recipe_b)
        click_link 'お気に入り登録'
        visit user_favorites_path(user_a)
        expect(page).to have_content recipe_b.name
      end
    end
  end
end
