class Search < ActiveRecord::Base
  CONTEXTS_FILTER = %w(Questions Answers Comments Users)
  
  def self.perform(query, contexts)
    return nil if query.try(:blank?)
    query = ThinkingSphinx::Query.escape(query)
    result = ThinkingSphinx.search(query, classes: Search.prepare(contexts))
  end
  
  def self.prepare(contexts)
    if contexts && contexts.is_a?(Array)
      contexts = CONTEXTS_FILTER & contexts 
      contexts.map! { |context| context.try(:singularize).try(:constantize) } if contexts
    else
      contexts = nil
    end
  end
end
