require 'rails_helper'

describe 'ユーザーの管理機能', type: :system do
  describe 'サインイン', js: true do
    let(:new_user) { FactoryBot.build(:user) }
    let(:blank_user) { FactoryBot.build(:user, name: '', email: '', password: '') }
    let(:no_confirmation) { FactoryBot.build(:user, password_confirmation: 'error_pass') }

    before do
      visit new_admin_user_path
      fill_in '名前', with: signin_user.name
      fill_in 'メールアドレス', with: signin_user.email
      fill_in 'パスワード', with: signin_user.password
      fill_in 'パスワード（確認）', with: signin_user.password_confirmation
      click_button '登録する'
    end

    context '入力が正しい場合' do
      let(:signin_user) { new_user }

      it '登録ができる' do
        expect(page).to have_selector '.alert-success', text: "ユーザー「#{new_user.name}」を登録しました"
        expect(page).to have_content(new_user.name)
      end
    end

    context '入力が不正だった場合' do
      context '情報が空の時' do
        let(:signin_user) { blank_user }

        it ' エラー' do
          within '#error_explanation' do
            expect(page).to have_content '名前を入力してください'
            expect(page).to have_content 'メールアドレスを入力してください'
            expect(page).to have_content 'パスワードを入力してください'
          end
        end
      end

      context 'パスワードの確認入力に失敗した時' do
        let(:signin_user) { no_confirmation }

        it 'エラー' do
          within '#error_explanation' do
            expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません'
          end
        end
      end
    end
  end

  describe '詳細表示' do
    let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@email.com') }
    let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@email.com') }
    let(:user_admin) { FactoryBot.create(:user, name: 'admin', email: 'admin@email.com', admin: true) }
    let!(:recipe_a) { FactoryBot.create(:recipe, user: user_a, name: 'Aのレシピ１') }
    let!(:recipe_b) { FactoryBot.create(:recipe, user: user_b, name: 'Bのレシピ１') }

    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end

    shared_examples_for 'Aのユーザー操作がすべて機能する' do
      it 'ユーザー詳細が表示される' do
        expect(page).to have_content user_a.name.to_s
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
        end.to change(User, :count).by(-1)
      end
    end
    context 'ユーザーAがログインしている場合' do
      let(:login_user) { user_a }

      context 'ユーザーAの詳細ページにて' do
        before do
          visit admin_user_path(user_a)
        end

        it_behaves_like 'Aのユーザー操作がすべて機能する'
      end

      context 'ユーザーBの詳細ページにて' do
        before do
          visit admin_user_path(user_b)
        end

        it 'ユーザーBの詳細が表示される' do
          expect(page).to have_content user_b.name.to_s
        end

        it '編集へのリンクが機能しない' do
          expect(page).not_to have_link '編集'
          visit edit_admin_user_path(user_b)
          expect(page).to have_no_current_path edit_admin_user_path(user_b), ignore_query: true
          expect(page).to have_current_path root_path, ignore_query: true
        end

        it '削除へのリンク表示されない' do
          expect(page).not_to have_link '削除'
        end
      end
    end

    context 'adminがログインしている場合' do
      let(:login_user) { user_admin }

      context 'ユーザーAの詳細ページにて' do
        before do
          visit admin_user_path(user_a)
        end

        it_behaves_like 'Aのユーザー操作がすべて機能する'
      end
    end
  end
end
