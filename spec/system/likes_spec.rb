require 'rails_helper'

RSpec.describe "Likes", type: :system do
  describe '確認観点1：Like機能' do
    let!(:user){ create(:user) }
    let(:another_user){ create(:user) }

    before do
      # 確認対象の画面に移動
      visit '/login'

      # labelの存在確認
      expect(page).to have_selector('label',text: 'Email'), 'Email というラベルが表示されていることを確認してください'
      expect(page).to have_selector('label', text: 'Password'), 'Password というラベルが表示されていることを確認してください'

      # labelとフィールドの対応付け確認
      expect(page).to have_css("label[for='email']"), 'Email というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'
      expect(page).to have_css("label[for='password']"), 'Password というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'

      # ログイン用ボタンの存在確認
      expect(page).to have_button('Login'), 'ログイン用のボタンが表示されていることを確認してください'

      # ユーザーログイン処理
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'Login'
    end

    it '1-1：他人の投稿をLikeすることができる' do
      post = create(:post, user: another_user)

      # 確認対象の画面に移動
      visit '/posts'

      # Likeリンクの存在確認
      expect(find('tbody')).to have_link('Like'), '他人の投稿にLike用のリンクが表示されているかを確認してください'
      expect { click_on 'Like' }.to change { Like.count }.by(1)

      visit 'posts/likes'

      # 処理結果の確認
      expect(page).to have_content(post.title), 'Likeした投稿のタイトルが表示されていません'
      expect(page).to have_content(post.content), 'Likeした投稿の本文が表示されていません'
      expect(page).not_to have_link('Edit'), 'Likeした投稿に編集用のリンクが表示されています'
      expect(page).not_to have_link('Destroy'), 'Likeした投稿に削除用のリンクが表示されています'
    end

    it '1-2：Likeした他人の投稿をUnLikeすることができる' do
      post = create(:post, user: another_user)

      # 確認対象の画面に移動
      visit '/posts'

      # Likeリンクの存在確認
      expect(find('tbody')).to have_link('Like'), '他人の投稿にLike用のリンクが表示されているかを確認してください'
      expect { click_on 'Like' }.to change { Like.count }.by(1)

      # UnLikeリンクの存在確認
      expect(find('tbody')).to have_link('UnLike'), '他人の投稿にUnLike用のリンクが表示されているかを確認してください'
      expect { click_on 'UnLike' }.to change { Like.count }.by(-1)

      visit 'posts/likes'

      # 処理結果の確認
      expect(page).not_to have_content(post.title), 'UnLikeした投稿のタイトルが表示されています'
      expect(page).not_to have_content(post.content), 'UnLikeした投稿の本文が表示されています'
    end

    it '1-3：自分の投稿をLikeすることができない' do
      post = create(:post, user: user)

      # 確認対象の画面に移動
      visit '/posts'

      # Likeリンクの存在確認
      expect(find('tbody')).not_to have_link('Like'), '自分の投稿にLike用のリンクが表示されていないかを確認してください'
    end
  end
 end
