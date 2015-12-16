class UrlMapper < EntityMapper

  map_for Url

  def create_candidate(url_val)
    Url.create!(
      url: url_val
    )
  end

  def find_candidates(url_val)
    Url.where(url: url_val)
  end

end
