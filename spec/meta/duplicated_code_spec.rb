require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# The tests in this file detect any changes made to Alaveteli views/partials that
# are used and modified by this Theme.
#
# If a test fails, copy the new version of the view to this Theme and redo the modifications.
# After that, copy the expected digest (shown when the test failed) to the
# test below to make it pass again. Alternatively, use the task file_digests :
#   bundle exec rake file_digests:compute[app/views/<etc>]

describe 'Checking views and partials used by this Theme' do
  def compare_digest(path, expected_digest)
    contents = File.read(path)
    digest = Digest::MD5.hexdigest(contents)
    expect(digest).to eq(expected_digest)
  end

  describe 'in general' do
    def path
      "#{Rails.root}/app/views/general/"
    end

    it 'signals a change in the nav items view' do
      compare_digest("#{path}_nav_items.html.erb", "3807c52e5eac3b36c45b2431c113bcf1")
    end

    it 'signals a change in the responsive footer view' do
      compare_digest("#{path}_responsive_footer.html.erb", "19e410b55424fc25449c45aae17bd7c9")
    end

    it 'signals a change in the search view' do
      compare_digest("#{path}search.html.erb", "48f301be2081ff83518ca3d828987882")
    end
  end

  describe 'in user' do
    def path
      "#{Rails.root}/app/views/user/"
    end

    it 'signals a change in the user show info view' do
      compare_digest("#{path}_show_user_info.html.erb", "103ff327fc313f293b5b2ad9528cf333")
    end
  end
end