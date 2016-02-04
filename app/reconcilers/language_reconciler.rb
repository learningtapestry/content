class LanguageReconciler < Reconciler
  def create(context)
    model.create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
  end
end
