require 'exceptions'

class SearchTerm
  attr_accessor :scope, :matching_scores, :max_results, :characters_limit

  def initialize(configuration={})
    @scope = configuration[:scope].to_a
    @matching_scores = configuration[:matching_scores]
    @characters_limit = configuration[:characters_limit]
  end

  def search(term, max_results=nil)
    raise Exceptions::SearchTermNotConfigured unless required_configuration
    results_hash = calculate_matching_scores(term, @scope)
    results = sort_and_convert_to_array(results_hash)
    results = limit_results(results, max_results) if max_results
    results
  end

  private

    def required_configuration
      @scope && @matching_scores
    end
    
    def calculate_matching_scores(term, scope)
      results_hash = {}
      scope.each do |item|
        total_score = calculate_matching_score_for(term, item)
        results_hash[item] = total_score unless total_score == 0
      end
      results_hash
    end

    def calculate_matching_score_for(term, item)
      @matching_scores.keys.inject(0) do |total_score, column| 
        term = sanitize_term(term)
        text = sanitize_text(item.send(column))
        total_score + text.scan(/#{term}/i).count * @matching_scores[column]
      end
    end

    def sort_and_convert_to_array(hash)
      sorted = hash.sort_by { |item, total_score| total_score }
      sorted.reverse.collect { |pair| pair.first } # <= [item, total_score] 
    end

    def sanitize_term(term)
      term.rstrip.lstrip
    end

    def sanitize_text(text)
      text ||= ""
      text = text[0..@characters_limit] if @characters_limit
      text
    end
  
    def limit_results(results, max_results)
      results[0...max_results]
    end
end
