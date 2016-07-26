class FinishMatchJob < Struct.new :match_id
  def perform
    match = Match.find_by id: match_id
    match.finish if match
  end
end
