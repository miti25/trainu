require 'rails_helper'

describe '作り方詳細（howto）の管理機能', type: :system do
  let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@email.com') }
  let!(:recipe_a) { create(:recipe, user: user_a, name: 'Aのレシピ１') }
  let!(:howto_1) { create(:howto, recipe: recipe_a, description: 'howto1', order_num: 1) }
  let!(:howto_2) { create(:howto, recipe: recipe_a, description: 'howto2', order_num: 2) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: user_a.email
    fill_in 'パスワード', with: user_a.password
    click_button 'ログイン'
  end

  context 'レシピ詳細ページにて' do
    before do
      visit recipe_path(recipe_a)
    end

    it 'howtoが表示される' do
      expect(page).to have_content howto_1.description
      expect(page).to have_content howto_2.description
    end

    it 'howtoの表示がorder_numの大きさに沿って降順' do
      expect(page.body.index(howto_1.description)).to be < page.body.index(howto_2.description)
    end
  end

  describe 'レシピ編集ページにて' do
    before do
      visit edit_recipe_path(recipe_a)
    end

    it 'howtoの新規作成ができる' do
      expect { click_on '追加' }.to change(Howto, :count).by(1)
    end

    context 'howtoの更新時' do
      before do
        within "#order-num#{howto_1.order_num}" do
          fill_in 'description', with: 'new_howto1'
          click_on '保存'
        end
        click_on '更新'
      end

      it '表示順は変わらない' do
        expect(page).to have_content 'new_howto1'
        expect(page).to have_content howto_2.description
        expect(page.body.index('new_howto1')).to be < page.body.index(howto_2.description)
      end
    end

    context 'howtoの削除時' do
      it '表示順は繰り上げされる' do
        expect do
          within "#order-num#{howto_1.order_num}" do
            click_on '削除'
          end
        end.to change(recipe_a.howtos, :count).by(-1)
        expect(page).to have_selector 'h3', text: 1
      end
    end
  end
end
