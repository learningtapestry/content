module CclsTasks
  extend self

  def subjects
    ['ela', 'math']
  end

  def load
    subjects.each do |subject|
      file = File.open Rails.root.join('db', 'json', "ccls_#{subject}.json")
      data = JSON.parse file.read
      # require 'pry'; binding.pry
      data.each { |root| parse_tree Hashie::Mash.new(root), nil }
    end
  end

  def parse_tree(root, parent_id)
    type = root.cls || 'leaf'  # folder || leaf
    data = send :"extract_from_#{type}", root
    # id = save_standard(data.merge parent: parent_id) if type == 'leaf'
    id = save_standard(data) if type == 'leaf'
    root.fetch(:children, []).each { |node| parse_tree(node, root) }
  end

  def extract_from_folder(h)
    {
      name: '', # ??
      description: h.text,
      url: h.id,
    }
  end

  def extract_from_leaf(h)
    {
      name: h.asn_statementNotation,
      description: h.text,
      url: h.id, #? skos_exactMatch.first.uri
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
