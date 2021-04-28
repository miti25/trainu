require 'rails_helper'

describe '管理者権限' do
  let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@email.com') }
  let(:user_admin) { create(:user, name: 'admin', email: 'admin@email.com', admin: true) }
  let!(:recipe_a) { create(:recipe, user: user_a, name: 'Aのレシピ１') }
  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end

  describe 'adminのユーザー管理機能' do
    context 'adminがログインしている場合' do
      let(:login_user) { user_admin }

      context 'ユーザーAの詳細ページにて' do
        before do
          visit admin_user_path(user_a)
        end
        it 'ユーザー詳細が表示される' do
          expect(page).to have_content user_a.name
        end

        it '編集へのリンクが機能する' do
          expect(page).to have_link '編集'
          click_on '編集'
          expect(page).to have_current_path edit_admin_user_path(user_a), ignore_query: true
        end

        it '削除へのリンクが機能する', js: true do
          expect(page).to have_link '削除'
          click_link '削除'
          expect do
            expect(page.accept_confirm).to eq "ユーザー「#{user_a.name}」を削除します、よろしいですか？"
            expect(page).to have_content "ユーザー「#{user_a.name}」を削除しました"
          end.to change{ User.count }.by(-1)
        end

        it '紐付いたレシピも削除される' do
          expect{ user_a.destroy }.to change{ Recipe.count }.by(-1)
        end
      end
    end
  end

  describe 'adminのレシピの管理機能', type: :system do

    describe 'レシピ詳細表示' do
      context 'adminがログインしている場合' do
        let(:login_user) { user_admin }

        context 'Aのレシピ詳細ページにて' do
          before do
            visit recipe_path(recipe_a)
          end

          it '作成したレシピ詳細が表示される' do
            expect(page).to have_content recipe_a.name
          end

          it '編集へのリンクが機能する' do
            expect(page).to have_link '編集'
            click_on '編集'
            expect(page).to have_current_path edit_recipe_path(recipe_a), ignore_query: true
          end

          it '削除へのリンクが機能する', js: true do
            expect(page).to have_link '削除'
            click_link '削除'
            expect do
              expect(page.accept_confirm).to eq "#{recipe_a.name}を削除します。よろしいですか？"
              expect(page).to have_content "レシピ「#{recipe_a.name}」を削除しました"
            end.to change(user_a.recipes, :count).by(-1)
          end
        end
      end
    end
  end
end