module CcssTasks
  extend self

  # Load CCSS standards from json files
  def load
    subjects.each do |subject|
      file = File.open Rails.root.join('db', 'json', "ccss_#{subject}.json")
      data = JSON.parse file.read
      data.each { |root| parse_tree Hashie::Mash.new(root) }
    end
  end

  # the CCSS subjects
  def subjects
    ['ela', 'math']
  end

  def is_leaf?(node)
    node.leaf == 'true'
  end

  def parse_tree(node)
    if is_leaf?(node)
      data = extract_data node
      save_standard data
    end
    node.fetch(:children, []).each { |new_node| parse_tree(new_node) }
  end

  def extract_data(h)
    {
      name: h.asn_statementNotation,
      description: h.text,
      url: h.skos_exactMatch.try(:first).try(:uri) || h.id,  # try to get corestandards.org URI first, else uses jesandco URI
      definitions: [
        h.asn_statementNotation,                # full identifier
        h.asn_altStatementNotation,             # simplified identifier
        h.id.split('/').last,                   # jesandco uri id
        h.skos_exactMatch.try(:last).try(:uri)  # urn:guid
      ].compact,
    }
  end

  def save_standard(data)
    if data[:name]
      Standard.find_or_create_by(name: data[:name]) do |s|
        s.assign_attributes **data
      end
    end
  end

end
