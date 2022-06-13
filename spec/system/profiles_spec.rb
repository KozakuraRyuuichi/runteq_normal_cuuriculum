require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  describe '確認観点1：Profile機能' do
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

    it '1-1：自分のProfileを編集することができる' do

      # 確認対象の画面に移動
      visit '/profile'

      # プロフィール編集ボタンの存在確認
      expect(page).to have_link('Edit Profile'), 'プロフィール編集ボタンが表示されているかを確認してください'

      click_on 'Edit Profile'

      # labelの存在確認
      expect(page).to have_selector('label', text: 'Email'), 'Email というラベルが表示されていることを確認してください'
      expect(page).to have_selector('label', text: 'Last name'), 'Last name というラベルが表示されていることを確認してください'
      expect(page).to have_selector('label', text: 'First name'), 'First name というラベルが表示されていることを確認してください'
      expect(page).to have_selector('label', text: 'Avatar'), 'Avatar というラベルが表示されていることを確認してください'

      # labelとフィールドの対応付け確認
      expect(page).to have_css("label[for='user_email']"), 'Email というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'
      expect(page).to have_css("label[for='user_last_name']"), 'Last name というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'
      expect(page).to have_css("label[for='user_first_name']"), 'First name というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'
      expect(page).to have_css("label[for='user_avatar']"), 'Avatar というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'

      fill_in 'Email', with: 'edited@example.com'
      fill_in 'Last name', with: 'last_name_edited'
      fill_in 'First name', with: 'first_name_edited'
      file_path = Rails.root.join('spec', 'fixtures', 'runteq.png')
      attach_file('Avatar', file_path)

      click_on 'Update'

      # 処理結果の確認
      expect(page).to have_content('edited@example.com'), '編集したメールアドレスが表示されていません'
      expect(page).to have_content('last_name_edited'), '編集したLast nameが表示されていません'
      expect(page).to have_content('first_name_edited'), '編集したFirst nameが表示されていません'
      expect(page).to have_selector("img[src$='runteq.png']"), '編集したアバター画像が表示されていません'
    end

    it '1-2：自分のProfileを空欄で編集することができない' do

      # 確認対象の画面に移動
      visit '/profile'

      # プロフィール編集ボタンの存在確認
      expect(page).to have_link('Edit Profile'), 'プロフィール編集ボタンが表示されているかを確認してください'

      click_on 'Edit Profile'

      # labelの存在確認
      expect(page).to have_selector('label', text: 'Email'), 'Email というラベルが表示されていることを確認してください'
      expect(page).to have_selector('label', text: 'Last name'), 'Last name というラベルが表示されていることを確認してください'
      expect(page).to have_selector('label', text: 'First name'), 'First name というラベルが表示されていることを確認してください'
      expect(page).to have_selector('label', text: 'Avatar'), 'Avatar というラベルが表示されていることを確認してください'

      # labelとフィールドの対応付け確認
      expect(page).to have_css("label[for='user_email']"), 'Email というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'
      expect(page).to have_css("label[for='user_last_name']"), 'Last name というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'
      expect(page).to have_css("label[for='user_first_name']"), 'First name というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'
      expect(page).to have_css("label[for='user_avatar']"), 'Avatar というラベルをクリックすると対応するフィールドにフォーカスすることを確認してください'

      fill_in 'Email', with: nil
      fill_in 'Last name', with: nil
      fill_in 'First name', with: nil
      # 画像添付

      click_on 'Update'

      # 処理結果の確認
      expect(page).to have_content("Email can't be blank"), 'Emailのバリデーションエラーメッセージが表示されていません'
      expect(page).to have_content("First name can't be blank"), 'First nameのバリデーションエラーメッセージが表示されていません'
      expect(page).to have_content("Last name can't be blank"), 'Last nameのバリデーションエラーメッセージが表示されていません'
    end

    it '1-3：ログインしていない状態でプロフィールを見ることができない' do
      # ユーザーログアウト処理
      find('#header-profile').click

      # ログアウト用ボタンの存在確認
      expect(page).to have_link('Logout'), 'ログアウトのボタンが表示されていることを確認してください'

      click_on 'Logout'

      # 確認対象の画面に移動
      visit '/profile'

      expect(page).to have_content('Please login first'), 'ログイン要求のメッセージが表示されていません'
      expect(current_path).to eq('/login'), 'ログインページに遷移していません'
    end
  end
 end
