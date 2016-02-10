class UrlReconciler < Reconciler
  def find(context)
    model.where url: context[:value]
  end

  def normalize(context)
    context[:value]
  end

  def create(context)
    model.create!(url: context[:value])
  end
end
