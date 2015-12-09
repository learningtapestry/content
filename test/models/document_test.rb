require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  setup do
    @blank_slate = documents(:published_blank_slate)
    @khan        = identities(:khan)
    @jason       = identities(:jason)
  end

  test '.find_by_url' do
    khan_url = 'https://www.khanacademy.org/math/algebra/introduction-to-algebra'
    assert_equal documents(:khan_intro_algebra), Document.find_by_url(khan_url)
  end

  test '#add_identity' do
    @blank_slate.add_identity(@jason, :submitter)
    @blank_slate.save!

    assert_not_nil DocumentIdentity.find_by(
      document: @blank_slate,
      identity: @jason,
      identity_type: IdentityType.submitter
    )
  end

  test '#identities_of' do
    @blank_slate.add_identity(@khan,  :publisher)
    @blank_slate.add_identity(@jason, :submitter)
    @blank_slate.save! ; @blank_slate.reload

    assert_includes @blank_slate.identities_of(:publisher), @khan
    assert_includes @blank_slate.identities_of(:submitter), @jason
    
    refute_includes @blank_slate.identities_of(:publisher), @jason
  end
end
