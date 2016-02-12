# One of the core features of the content system is reconciling arbitrary
# user input with entities in our database.
#
# A ValueMapping has two purposes:
# 1. It caches the results of previous automatic reconciliation attempts.
# 2. If the user displays a preference for a particular reconciliation result,
#    their preference is stored as a value mapping.
class ValueMapping < ActiveRecord::Base
  belongs_to :repository
  belongs_to :mappable, polymorphic: true
end
