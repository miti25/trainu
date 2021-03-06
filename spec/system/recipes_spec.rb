require 'rails_helper'

describe 'レシピの管理機能', type: :system do
  let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@email.com') }
  let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@email.com') }
  let!(:recipe_a) { create(:recipe, user: user_a, name: 'Aのレシピ１') }
  let!(:recipe_b) { create(:recipe, user: user_b, name: 'Bのレシピ１') }

  describe '非ログイン時' do
    context 'Aのレシピ１詳細ページにて' do
      before do
        visit recipe_path(recipe_a)
      end

      it 'レシピが表示される' do
        expect(page).to have_content recipe_a.name
      end

      it '編集へのリンクが機能しない' do
        expect(page).not_to have_link '編集'
        visit edit_recipe_path(recipe_a)
        expect(page).not_to have_current_path edit_recipe_path(recipe_a), ignore_query: true
      end

      it '削除へのリンク表示されない' do
        expect(page).not_to have_link '削除'
      end
    end
  end

  describe 'ログイン時' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end

    describe '一覧表示' do
      context 'ユーザーAがログインしている場合' do
        let(:login_user) { user_a }

        it 'ユーザーAの作成したレシピが表示される' do
          expect(page).to have_content recipe_a.name
        end
      end

      context 'ユーザーBがログインしている場合' do
        let(:login_user) { user_b }

        it 'ユーザーBのレシピとユーザーAが作成したレシピが表示される' do
          expect(page).to have_content recipe_b.name
          expect(page).to have_content recipe_a.name
        end
      end
    end

    describe '詳細表示' do
      context 'ユーザーAがログインしている場合' do
        let(:login_user) { user_a }

        context 'Aのレシピ詳細ページにて' do
          before do
            visit recipe_path(recipe_a)
          end

          it '作成したレシピ詳細が表示される' do
            expect(page).to have_content recipe_a.user.name
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

        context 'Bレシピ詳細ページにて' do
          before do
            visit recipe_path(recipe_b)
          end

          it 'ユーザーBの作成したレシピが表示される' do
            expect(page).to have_content recipe_b.name
          end

          it '編集へのリンクが機能しない' do
            expect(page).not_to have_link '編集'
            visit edit_recipe_path(recipe_b)
            expect(page).not_to have_current_path edit_recipe_path(recipe_b), ignore_query: true
          end

          it '削除へのリンク表示されない' do
            expect(page).not_to have_link '削除'
          end
        end
      end
    end

    describe '新規作成' do
      let(:login_user) { user_a }
      let(:recipe_name) { '新規作成テスト' }

      before do
        visit new_recipe_path
        fill_in 'recipe[name]', with: recipe_name
        click_button 'レシピ詳細の入力に進む'
      end

      context 'レシピが正常だった場合' do
        it '編集ページへ移行' do
          expect(page).to have_current_path edit_recipe_path(Recipe.find_by(name: recipe_name)), ignore_query: true
        end
      end

      context 'レシピが不正だった場合' do
        context 'レシピ名が空の時' do
          let(:recipe_name) { '' }

          it ' エラー' do
            within '#error_explanation' do
              expect(page).to have_content 'レシピ名を入力してください'
            end
          end
        end

        context 'レシピ名が長過ぎる時' do
          let(:recipe_name) { 'a' * 31 }

          it 'エラー' do
            within '#error_explanation' do
              expect(page).to have_content 'レシピ名は30文字以内で入力してください'
            end
          end
        end
      end
    end
  end
end
