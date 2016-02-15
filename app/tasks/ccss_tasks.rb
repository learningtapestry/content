module CcssTasks
  extend self

  def subjects
    ['ela', 'math']
  end

  def load
    subjects.each do |subject|
      file = File.open Rails.root.join('db', 'json', "ccss_#{subject}.json")
      data = JSON.parse file.read
      data.each { |root| parse_tree Hashie::Mash.new(root) }
    end
  end

  def parse_tree(root)
    is_leaf = root.cls != 'folder'
    if is_leaf
      data = extract_data root
      save_standard data
    end
    root.fetch(:children, []).each { |node| parse_tree(node) }
  end

  def extract_data(h)
    {
      name: h.asn_statementNotation,
      description: h.text,
      url: h.skos_exactMatch.try(:first).try(:uri) || h.id,
      definitions: [
        h.asn_statementNotation,
        h.asn_altStatementNotation,
        h.id.split('/').last,
        h.skos_exactMatch.try(:last).try(:uri)
      ].compact,
    }
  end

  def save_standard(data)
    puts "======"
    puts data
  end

end
