class StartMatchJob < Struct.new :match_id
  def perform
    match = Match.find_by id: match_id
    match.start if match
  end
end
