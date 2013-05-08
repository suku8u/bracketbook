module BracketsHelper
  def win_loss_indicator(team1_score, team2_score)
    case
    when team1_score > team2_score
      "badge-success"
    when team2_score > team1_score
      "badge-important"
    else
      ""
    end
  end
end
