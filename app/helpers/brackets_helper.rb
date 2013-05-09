module BracketsHelper
  def win_loss_indicator(team1_score, team2_score, name)
    class_string = ""
    case
    when team1_score > team2_score
      class_string += "badge-success"
    when team2_score > team1_score
      class_string += "badge-important"
    else
      ""
    end
    if name.downcase == "bye"
      class_string += " hidden"
    end
    return class_string
  end
end
