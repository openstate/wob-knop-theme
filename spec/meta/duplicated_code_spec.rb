require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# The tests in this file detect any changes made to Alaveteli views/partials and methods that
# are used and modified by this Theme.
#
# If a test fails for a view or method, copy the new version to this Theme and redo the modifications.
# After that, copy the expected digest (shown when the test failed) to the
# test below to make it pass again. Alternatively, use the task file_digests for a view:
#   bundle exec rake file_digests:compute[app/views/<etc>]

describe 'Checking views and partials used by this Theme' do
  def compare_view_digest(path, expected_digest)
    contents = File.read(path)
    digest = Digest::MD5.hexdigest(contents)
    expect(digest).to eq(expected_digest)
  end

  describe 'in general' do
    def path
      "#{Rails.root}/app/views/general/"
    end

    it 'signals a change in the nav items view' do
      compare_view_digest("#{path}_nav_items.html.erb", "3807c52e5eac3b36c45b2431c113bcf1")
    end

    it 'signals a change in the responsive footer view' do
      compare_view_digest("#{path}_responsive_footer.html.erb", "19e410b55424fc25449c45aae17bd7c9")
    end

    it 'signals a change in the search view' do
      compare_view_digest("#{path}search.html.erb", "e0f9cfaaef501c3cac1581c3989246e7")
    end
  end

  describe 'in followups' do
    def path
      "#{Rails.root}/app/views/followups/"
    end
    
    it 'signals a change in the preview view' do
      compare_view_digest("#{path}preview.html.erb", "9528ddff73f7e8d73864cd165d49ffc3")
    end

    it 'signals a change in the _followup view' do
      compare_view_digest("#{path}_followup.html.erb", "1ecb69ee0bf8a520f7ec496e4be3b465")
    end

    it 'signals a change in the _preview_notes view' do
      compare_view_digest("#{path}_preview_notes.html.erb", "0f4a4e6f50d83efd7805a5c1131241d0")
    end
  end

  describe 'in outgoing_mailer' do
    def path
      "#{Rails.root}/app/views/outgoing_mailer/"
    end
    
    it 'signals a change in the followup view' do
      compare_view_digest("#{path}followup.text.erb", "4900383ae1a4b6f162ee5a4a1cca7c38")
    end

    it 'signals a change in the initial_request view' do
      compare_view_digest("#{path}initial_request.text.erb", "7a7e8b2a71b206d1a8d1a8c928b02570")
    end
  end

  describe 'in request' do
    def path
      "#{Rails.root}/app/views/request/"
    end

    it 'signals a change in the _form view' do
      compare_view_digest("#{path}_form.html.erb", "5637b61e75c68add11e727d8e22a6107")
    end

    it 'signals a change in the _preview_notes view' do
      compare_view_digest("#{path}_preview_notes.html.erb", "d9441f1398b7d6d6101af5cc514f2011")
    end

    it 'signals a change in the preview view' do
      compare_view_digest("#{path}preview.html.erb", "13288d2d20a13d38f37a461e06d49fa0")
    end
  end

  describe 'in user' do
    def path
      "#{Rails.root}/app/views/user/"
    end

    it 'signals a change in the user show info view' do
      compare_view_digest("#{path}_show_user_info.html.erb", "66a19d1ef0b58a5358256ffb60a5fd31")
    end
  end
end

describe 'Checking methods overridden by this Theme' do
  def compare_method_digest(method, expected_digest)
    contents = method.source
    digest = Digest::MD5.hexdigest(contents)
    expect(digest).to eq(expected_digest)
  end

  it 'signals a change in user_controller.user_params' do
    compare_method_digest(UserController.new.method(:unaliased_user_params), "aae12596ec964e483b150c31730437f9")
  end
end
